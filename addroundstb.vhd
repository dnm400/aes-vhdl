----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.07.2024 16:01:58
-- Design Name: 
-- Module Name: addroundstb - Behavioral
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

entity testbench is
end testbench;

architecture Behavioral of testbench is
    signal clockk : std_logic := '0';
    signal resett : std_logic := '0';
    signal pall_i: STD_LOGIC_VECTOR(127 DOWNTO 0):= x"3243f6a8885a308d313198a2e0370734";
    signal keyall_i: STD_LOGIC_VECTOR(127 DOWNTO 0):=   x"2b7e151628aed2a6abf7158809cf4f3c";
    signal cipherall_o : std_logic_vector(127 downto 0);
    
begin
    uut : entity work.aesfaster
        port map (
            clockk => clockk,
            resett => resett,
            pall_i => pall_i,
            keyall_i => keyall_i,
            cipherall_o => cipherall_o
        ); 
 
    clk_process : process
    begin
        while true loop
            clockk <= '0'; 
            wait for 10 ns;
            clockk <= '1';
            wait for 10 ns;
        end loop;
    end process;
end Behavioral;