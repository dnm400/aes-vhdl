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
    signal cipherall_o : std_logic_vector(127 downto 0);
begin
    uut : entity work.allrounds
        port map (
            clockk => clockk,
            resett => resett,
            cipherall_o => cipherall_o
        );

    clk_process : process
    begin
        while true loop
            clockk <= '0'; 
            wait for 1 ns;
            clockk <= '1';
            wait for 1 ns;
        end loop;
    end process;
end Behavioral;