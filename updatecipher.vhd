----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.07.2024 13:53:42
-- Design Name: 
-- Module Name: updatecipher - Behavioral
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

entity updatecipher is
Port (clk    : in STD_LOGIC;
    rst    : in STD_LOGIC;
    thekey : in STD_LOGIC_VECTOR(127 downto 0);
    RCont : in STD_LOGIC_VECTOR(31 downto 0);
    updatedkey  : out STD_LOGIC_VECTOR(127 downto 0)
     );
end updatecipher;

architecture Behavioral of updatecipher is
--signal RCont : STD_LOGIC_VECTOR(31 downto 0) := x"02000000";
--signal thekey : STD_LOGIC_VECTOR(127 downto 0) := x"2b7e151628aed2a6abf7158809cf4f3c";
--signal clk: std_logic := '0';

type sboxa is array (0 to 255) of std_logic_vector(7 downto 0);
constant sbox : sboxa :=
(
        x"63", x"7C", x"77", x"7B", x"F2", x"6B", x"6F", x"C5", 
        x"30", x"01", x"67", x"2B", x"FE", x"D7", x"AB", x"76", 
        x"CA", x"82", x"C9", x"7D", x"FA", x"59", x"47", x"F0", 
        x"AD", x"D4", x"A2", x"AF", x"9C", x"A4", x"72", x"C0", 
        x"B7", x"FD", x"93", x"26", x"36", x"3F", x"F7", x"CC", 
        x"34", x"A5", x"E5", x"F1", x"71", x"D8", x"31", x"15", 
        x"04", x"C7", x"23", x"C3", x"18", x"96", x"05", x"9A", 
        x"07", x"12", x"80", x"E2", x"EB", x"27", x"B2", x"75", 
        x"09", x"83", x"2C", x"1A", x"1B", x"6E", x"5A", x"A0", 
        x"52", x"3B", x"D6", x"B3", x"29", x"E3", x"2F", x"84", 
        x"53", x"D1", x"00", x"ED", x"20", x"FC", x"B1", x"5B", 
        x"6A", x"CB", x"BE", x"39", x"4A", x"4C", x"58", x"CF", 
        x"D0", x"EF", x"AA", x"FB", x"43", x"4D", x"33", x"85", 
        x"45", x"F9", x"02", x"7F", x"50", x"3C", x"9F", x"A8", 
        x"51", x"A3", x"40", x"8F", x"92", x"9D", x"38", x"F5", 
        x"BC", x"B6", x"DA", x"21", x"10", x"FF", x"F3", x"D2", 
        x"CD", x"0C", x"13", x"EC", x"5F", x"97", x"44", x"17", 
        x"C4", x"A7", x"7E", x"3D", x"64", x"5D", x"19", x"73", 
        x"60", x"81", x"4F", x"DC", x"22", x"2A", x"90", x"88", 
        x"46", x"EE", x"B8", x"14", x"DE", x"5E", x"0B", x"DB", 
        x"E0", x"32", x"3A", x"0A", x"49", x"06", x"24", x"5C", 
        x"C2", x"D3", x"AC", x"62", x"91", x"95", x"E4", x"79", 
        x"E7", x"C8", x"37", x"6D", x"8D", x"D5", x"4E", x"A9", 
        x"6C", x"56", x"F4", x"EA", x"65", x"7A", x"AE", x"08", 
        x"BA", x"78", x"25", x"2E", x"1C", x"A6", x"B4", x"C6", 
        x"E8", x"DD", x"74", x"1F", x"4B", x"BD", x"8B", x"8A", 
        x"70", x"3E", x"B5", x"66", x"48", x"03", x"F6", x"0E", 
        x"61", x"35", x"57", x"B9", x"86", x"C1", x"1D", x"9E", 
        x"E1", x"F8", x"98", x"11", x"69", x"D9", x"8E", x"94", 
        x"9B", x"1E", x"87", x"E9", x"CE", x"55", x"28", x"DF", 
        x"8C", x"A1", x"89", x"0D", x"BF", x"E6", x"42", x"68", 
        x"41", x"99", x"2D", x"0F", x"B0", x"54", x"BB", x"16"
    ); 
signal v0, v1, v2, v3, rv3, s3 : std_logic_vector(31 downto 0);
signal v0u, v1u, v2u, v3u : std_logic_vector(31 downto 0);
signal sv : std_logic_vector(31 downto 0);

function rotword ( 
    rotw_i : in STD_LOGIC_VECTOR (31 downto 0)) return STD_LOGIC_VECTOR is
    variable rotw_o : STD_LOGIC_VECTOR(31 downto 0);
    begin
        rotw_o := rotw_i(23 downto 16) & rotw_i(15 downto 8) & rotw_i(7 downto 0) & rotw_i (31 downto 24);
        return rotw_o;
end function;

begin

--       clk_process : process
--    begin
--        while true loop
--            clk <= '0';
--            wait for 10 ns;
--            clk <= '1';
--            wait for 10 ns;
--        end loop;
--    end process;
    process(clk, rst)
    begin
        if rst = '1' then 
            updatedkey <= (others => '0');
            v0 <= (others => '0');
            v1 <= (others => '0');
            v2 <= (others => '0');
            v3 <= (others => '0');
            rv3 <= (others => '0');
            sv <= (others => '0');
            s3 <= (others => '0');
            v0u <= (others => '0');
            v1u <= (others => '0');
            v2u <= (others => '0');
            v3u <= (others => '0');
        elsif rising_edge(clk) then
            v0 <= thekey(127 downto 96);
            v1 <= thekey(95 downto 64);
            v2 <= thekey(63 downto 32);
            v3 <= thekey(31 downto 0);
            
            rv3 <= rotword(v3);
            sv <= sbox(to_integer(unsigned(rv3(31 downto 24)))) &
                  sbox(to_integer(unsigned(rv3(23 downto 16)))) &
                  sbox(to_integer(unsigned(rv3(15 downto 8)))) &
                  sbox(to_integer(unsigned(rv3(7 downto 0))));
            
            s3 <= sv;
            v0u <= v0 xor s3 xor RCont;
            v1u <= v1 xor v0u;
            v2u <= v2 xor v1u;
            v3u <= v3 xor v2u;
            
            updatedkey <= v0u & v1u & v2u & v3u;
        end if;
    end process;
end Behavioral;
