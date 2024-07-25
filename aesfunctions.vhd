----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.07.2024 15:59:55
-- Design Name: 
-- Module Name: aesfunctions - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED;
use IEEE.STD_LOGIC_ARITH;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity aesfunctions is --for 128-bit plaintext
Port (  plaintext : in STD_LOGIC_VECTOR (127 downto 0);
    key: in STD_LOGIC_VECTOR (127 downto 0);
    ciphertext : out STD_LOGIC_VECTOR (127 downto 0);
    RCont : in STD_LOGIC_VECTOR(31 downto 0)
    );
end aesfunctions;

architecture Behavioral of aesfunctions is

type Rconarray is array (0 to 9) of std_logic_vector(31 downto 0);

signal Rcon : Rconarray := (
   x"01000000",
   x"02000000",
   x"04000000",
   x"08000000",
   x"10000000",
   x"20000000",
   x"40000000",
   x"80000000",
   x"1B000000",
   x"36000000"
);

component subbytes is
Port ( 
    sub_i : in STD_LOGIC_VECTOR (127 downto 0);
    sub_o : out STD_LOGIC_VECTOR (127 downto 0)   
    );
end component;

component shiftrows is
    Port (  shifttext_i : in STD_LOGIC_VECTOR (127 downto 0);
            shifttext_o : out STD_LOGIC_VECTOR (127 downto 0)
            );
end component;

component mixcolumns is --for a vector
Port (
       mix_i : in STD_LOGIC_VECTOR (31 downto 0);
       mix_o : out STD_LOGIC_VECTOR (31 downto 0) );
end component;

component addroundkey is
Port (
    ptext : in STD_LOGIC_VECTOR (127 downto 0);
    key: in STD_LOGIC_VECTOR (127 downto 0);
    ctext : out STD_LOGIC_VECTOR (127 downto 0)  );
end component;

component updatecipher is
Port (
    thekey : in STD_LOGIC_VECTOR(127 downto 0);
    RCont : in STD_LOGIC_VECTOR(31 downto 0);
    updatedkey  : out STD_LOGIC_VECTOR(127 downto 0)
     );
end component;

signal sub_o, shift_o, mix_o, key_o: STD_LOGIC_VECTOR (127 downto 0);
signal mixvec0, mixvec1, mixvec2, mixvec3, mixvec0_o, mixvec1_o, mixvec2_o, mixvec3_o: STD_LOGIC_VECTOR (31 downto 0);

begin

submodule: subbytes port map(
     sub_i => plaintext,
     sub_o => sub_o);

shiftmodule: shiftrows port map(
    shifttext_i => sub_o,
    shifttext_o => shift_o);

mixvec0 <= shift_o(127 downto 96);
mixvec1 <= shift_o(95 downto 64);
mixvec2 <= shift_o(63 downto 32);
mixvec3 <= shift_o(31 downto 0);

mix0: mixcolumns port map(
    mix_i => mixvec0,
    mix_o => mixvec0_o);
    
mix1: mixcolumns port map(
    mix_i => mixvec1,
    mix_o => mixvec1_o);
    
mix2: mixcolumns port map(
    mix_i => mixvec2,
    mix_o => mixvec2_o);
    
mix3: mixcolumns port map(
    mix_i => mixvec3,
    mix_o => mixvec3_o);

mix_o <= mixvec0_o & mixvec1_o & mixvec2_o & mixvec3_o;

updatec: updatecipher port map(
    thekey => key,
    Rcont => Rcont,
    updatedkey => key_o);
    
addround: addroundkey port map(
    ptext => mix_o,
    key => key_o,
    ctext => ciphertext);
    
end Behavioral;
