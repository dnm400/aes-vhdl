----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.07.2024 08:40:48
-- Design Name: 
-- Module Name: shiftrows - Behavioral
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

entity shiftrows is
    Port (  shifttext_i : in STD_LOGIC_VECTOR (127 downto 0);
            shifttext_o : out STD_LOGIC_VECTOR (127 downto 0)
            );
end shiftrows;

architecture Behavioral of shiftrows is
    signal s00, s01, s02, s03, s10, s11, s12, s13, s20, s21, s22, s23, s30,s31, s32, s33 : std_logic_vector(7 downto 0);
begin
    S00 <= shifttext_i(127 downto 120);
    S10 <= shifttext_i(119 downto 112);
    S20 <= shifttext_i(111 downto 104);
    S30 <= shifttext_i(103 downto 96);
    S01 <= shifttext_i(95 downto 88);
    S11<= shifttext_i(87 downto 80);
    S21 <= shifttext_i(79 downto 72);
    S32 <= shifttext_i(71 downto 64);
    S02 <= shifttext_i(63 downto 56);
    S12 <= shifttext_i(55 downto 48);
    S22 <= shifttext_i(47 downto 40);
    S32 <= shifttext_i(39 downto 32);
    S03 <= shifttext_i(31 downto 24);
    S13 <= shifttext_i(23 downto 16);
    S23 <= shifttext_i(15 downto 8);
    S33 <= shifttext_i(7 downto 0);

    shifttext_o <= s00 & s11 & s22 & s33 & s01 & s12 & s23 & s30 & s02 & s13 & s20 & s31 & s03 & s10 & s21 & s32 ;
end Behavioral;
