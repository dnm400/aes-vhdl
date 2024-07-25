----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.07.2024 14:12:17
-- Design Name: 
-- Module Name: allrounds - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity allrounds is
Port ( pall_i : in STD_LOGIC_VECTOR (127 downto 0);
    keyall_i: in STD_LOGIC_VECTOR (127 downto 0);
    cipherall_o : out STD_LOGIC_VECTOR (127 downto 0)
    );
end allrounds;

architecture Behavioral of allrounds is

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

component aesfunctions is 
Port (  plaintext : in STD_LOGIC_VECTOR (127 downto 0);
    key: in STD_LOGIC_VECTOR (127 downto 0);
    ciphertext : out STD_LOGIC_VECTOR (127 downto 0);
    RCont : in STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

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

signal c0, c9, sub10_o, shift10_o, update10_o  : STD_LOGIC_VECTOR (127 downto 0);
type ninerounds is array (1 to 10) of std_logic_vector(127 downto 0);
signal p_o, k_o: ninerounds; 
begin 

r0: addroundkey port map(
    ptext => pall_i,
    key => keyall_i,
    ctext => c0);

gen_rounds : for i in 1 to 9 generate
begin
    aes_gen: aesfunctions
    Port map (
                plaintext => p_o(i),
                key => k_o(i),
                ciphertext => p_o(i + 1),
                RCont => RCon(i-1)
            );
end generate gen_rounds;
c9 <= p_o(10);

r10_sub: subbytes port map(
     sub_i => c9,
     sub_o => sub10_o);

r10_shift: shiftrows port map(
    shifttext_i => sub10_o,
    shifttext_o => shift10_o);

r10_update: updatecipher port map(
    thekey => k_o(9),
    Rcont => Rcon(9),
    updatedkey => update10_o);
 
 r10_add: addroundkey port map(
    ptext => shift10_o,
    key => update10_o,
    ctext => update10_o);
    

end Behavioral;
