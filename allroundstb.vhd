----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.07.2024 10:27:59
-- Design Name: 
-- Module Name: allroundstb - Behavioral
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

entity allroundstb is
end allroundstb;

architecture Behavioral of allroundstb is
    signal clockk   : std_logic := '0';
    signal resett   : std_logic := '0';
    signal cipherall_o : std_logic_vector(127 downto 0);

component allrounds
Port (  clockk    :   in STD_LOGIC;      
        resett    : in STD_LOGIC;
    --pall_i : in STD_LOGIC_VECTOR (127 downto 0);
   --keyall_i: in STD_LOGIC_VECTOR (127 downto 0);
    cipherall_o : out STD_LOGIC_VECTOR (127 downto 0)
    );
end component;

begin
    clk_process : process
    begin
        while true loop
            clockk <= '0';
            wait for 10 ns;
            clockk <= '1';
            wait for 10 ns;
        end loop;
    end process;

 stim_proc : process
    begin
        -- Apply reset
        resett <= '1';
        wait for 20 ns;
        resett <= '0';

        -- Wait for a few clock cycles to observe the output
        wait for 200 ns;

        -- Stop the simulation
        wait;
    end process;

    uut: allrounds
        port map (
            clockk => clockk,
            resett => resett,
            cipherall_o => cipherall_o
        );

end Behavioral;