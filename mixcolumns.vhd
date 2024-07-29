----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.07.2024 09:21:06
-- Design Name: 
-- Module Name: mixcolumns - Behavioral
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

entity mixcolumns is --for a vector
Port ( clk    : in STD_LOGIC;
       rst    : in STD_LOGIC;
       mix_i : in STD_LOGIC_VECTOR (31 downto 0);
       mix_o : out STD_LOGIC_VECTOR (31 downto 0) );
end mixcolumns;

architecture Behavioral of mixcolumns is
    --signal mix_i : STD_LOGIC_VECTOR (31 downto 0):= x"d4bf5d30";
    signal v0, v1, v2, v3, v0t, v1t, v2t, v3t: std_logic_vector(7 downto 0);
    
    type state_type is (IDLE, LOAD_INPUT, LOADED, OUTPUT_RESULT);
    signal state: state_type := IDLE;

function gfmul2(
        gf2_i : in STD_LOGIC_VECTOR(7 downto 0)) return STD_LOGIC_VECTOR is
        variable gf2_o : STD_LOGIC_VECTOR(7 downto 0);
        
begin
    gf2_o := gf2_i(6 downto 0) & '0';
    if gf2_i(7) = '1' then
        gf2_o := gf2_o xor "00011011";
    end if;
    return gf2_o;
end function;

function gfmul3(
        gf3_i : in STD_LOGIC_VECTOR(7 downto 0)) return STD_LOGIC_VECTOR is
        variable gf3_o : STD_LOGIC_VECTOR(7 downto 0);
        
begin
        return gfmul2(gf3_i) xor gf3_i;
end function;

begin
    process(clk,rst)
    begin
  if rst = '1' then
    mix_o <= (others => '0');
    state <= IDLE;
  elsif clk = '1' then
  case state is
   when IDLE =>
       state <= LOAD_INPUT;
   when LOAD_INPUT =>
    v0 <= mix_i(31 downto 24);
    v1 <= mix_i(23 downto 16);
    v2 <= mix_i(15 downto 8);
    v3 <= mix_i(7 downto 0);
    state <= LOADED;
   when LOADED =>
    v0t <= gfmul2(v0) xor gfmul3(v1) xor v2 xor v3;
    v1t <= v0 xor gfmul2(v1) xor gfmul3(v2) xor v3;
    v2t <= v0 xor v1 xor gfmul2(v2) xor gfmul3(v3);
    v3t <= gfmul3(v0) xor v1 xor v2 xor gfmul2(v3);
    state <= OUTPUT_RESULT ;
    when OUTPUT_RESULT =>
    mix_o <= v0t & v1t & v2t & v3t;
    state <= IDLE;
    end case;
    end if;
    end process;

end Behavioral;
