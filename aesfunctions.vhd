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
Port (  clkfn    : in STD_LOGIC;
        rstfn  : in STD_LOGIC;
    plaintext : in STD_LOGIC_VECTOR (127 downto 0);
    key: in STD_LOGIC_VECTOR (127 downto 0);
    ciphertext : out STD_LOGIC_VECTOR (127 downto 0);
    RCont : in STD_LOGIC_VECTOR(31 downto 0);
    keyout: out STD_LOGIC_VECTOR (127 downto 0)
    );
end aesfunctions;

architecture Behavioral of aesfunctions is

--signal plaintext :  STD_LOGIC_VECTOR (127 downto 0) := x"193de3bea0f4e22b9ac68d2ae9f84808";
--signal    key:  STD_LOGIC_VECTOR (127 downto 0) := x"2b7e151628aed2a6abf7158809cf4f3c";
--signal    RCont :  STD_LOGIC_VECTOR(31 downto 0) :=  x"01000000" ;

component subbytes is
Port ( clk    : in STD_LOGIC;
        rst    : in STD_LOGIC;
    sub_i : in STD_LOGIC_VECTOR (127 downto 0);
    sub_o : out STD_LOGIC_VECTOR (127 downto 0)   
    );
end component;

component shiftrows is
    Port (  clk    : in STD_LOGIC;
            rst    : in STD_LOGIC;
            shifttext_i : in STD_LOGIC_VECTOR (127 downto 0);
            shifttext_o : out STD_LOGIC_VECTOR (127 downto 0)
            );
end component;

component mixcolumns is --for a vector
Port (  clk    : in STD_LOGIC;
       rst    : in STD_LOGIC;
       mix_i : in STD_LOGIC_VECTOR (31 downto 0);
       mix_o : out STD_LOGIC_VECTOR (31 downto 0) );
end component;

component addroundkey is
Port (clk    : in STD_LOGIC;
    rst    : in STD_LOGIC;
    ptext : in STD_LOGIC_VECTOR (127 downto 0);
    key: in STD_LOGIC_VECTOR (127 downto 0);
    ctext : out STD_LOGIC_VECTOR (127 downto 0)  );
end component;

component updatecipher is
Port (
    clk    : in STD_LOGIC;
    rst    : in STD_LOGIC;
    thekey : in STD_LOGIC_VECTOR(127 downto 0);
    RCont : in STD_LOGIC_VECTOR(31 downto 0);
    updatedkey  : out STD_LOGIC_VECTOR(127 downto 0)
     );
end component;

signal sub_o, shift_o, mix_o, key_o: STD_LOGIC_VECTOR (127 downto 0);
signal mixvec0, mixvec1, mixvec2, mixvec3, mixvec0_o, mixvec1_o, mixvec2_o, mixvec3_o: STD_LOGIC_VECTOR (31 downto 0);

begin
submodule: subbytes port map(
     clk => clkfn ,
     rst => rstfn,
     sub_i => plaintext,
     sub_o => sub_o);

shiftmodule: shiftrows port map(
    clk => clkfn ,
     rst => rstfn,
    shifttext_i => sub_o,
    shifttext_o => shift_o);
    
   process(clkfn, rstfn)
    begin
        if rstfn = '1' then
            mixvec0 <= (others => '0');
            mixvec1 <= (others => '0');
            mixvec2 <= (others => '0');
            mixvec3 <= (others => '0');
        elsif rising_edge(clkfn) then
        mixvec0 <= shift_o(127 downto 96);
        mixvec1 <= shift_o(95 downto 64);
        mixvec2 <= shift_o(63 downto 32);
        mixvec3 <= shift_o(31 downto 0);
       end if;   
   end process;


mix0: mixcolumns port map(
    clk => clkfn ,
     rst => rstfn,
    mix_i => mixvec0,
    mix_o => mixvec0_o);
    
mix1: mixcolumns port map(
    clk => clkfn ,
     rst => rstfn,
    mix_i => mixvec1,
    mix_o => mixvec1_o);
    
mix2: mixcolumns port map(
    clk => clkfn ,
     rst => rstfn,
    mix_i => mixvec2,
    mix_o => mixvec2_o);
    
mix3: mixcolumns port map(
    clk => clkfn ,
     rst => rstfn,
    mix_i => mixvec3,
    mix_o => mixvec3_o);
    
      process(clkfn)
    begin
    if rising_edge(clkfn) then
        mix_o <= mixvec0_o & mixvec1_o & mixvec2_o & mixvec3_o;
        end if; 
    end process;

updatec: updatecipher port map(
     clk => clkfn ,
     rst => rstfn,
    thekey => key,
    Rcont => Rcont,
    updatedkey => key_o);
    
addround: addroundkey port map(
    clk => clkfn ,
     rst => rstfn,
    ptext => mix_o,
    key => key_o,
    ctext => ciphertext);
    
keyout <= key_o;
    
end Behavioral;
