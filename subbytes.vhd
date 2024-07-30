    ----------------------------------------------------------------------------------
    -- Company: 
    -- Engineer: 
    -- 
    -- Create Date: 24.07.2024 11:04:30
    -- Design Name: 
    -- Module Name: subbytes - Behavioral
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
    use IEEE.NUMERIC_STD.ALL;
    
    entity subbytes is
        Port ( clk    : in STD_LOGIC;
            rst    : in STD_LOGIC;
          sub_i: in STD_LOGIC_VECTOR(127 downto 0);
            sub_o : out STD_LOGIC_VECTOR (127 downto 0)
        );
    end subbytes;
    
    architecture Behavioral of subbytes is
    --    constant sub_i: STD_LOGIC_VECTOR(127 downto 0) := x"193de3bea0f4e22b9ac68d2ae9f84808";
        type sboxa is array (0 to 255) of std_logic_vector(7 downto 0);
        constant sbox : sboxa := (
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
        type elar is array (0 to 15) of std_logic_vector(7 downto 0);
        signal elements: elar;
--        type matrix is array (0 to 3, 0 to 3) of std_logic_vector(7 downto 0);
--        signal elements: matrix;
    --    signal clk : std_logic := '0';
--        type state_type is (IDLE, LOAD_INPUT, SUB_BYTES, OUTPUT_RESULT);
--        signal state: state_type := IDLE;
    begin
    
    --     clk_process : process
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
--                state <= IDLE;
                sub_o <= (others => '0');
--                for i in 0 to 3 loop
--                            for j in 0 to 3 loop
                                elements(0) <= (others => '0');
                                elements(1) <= (others => '0');
                                elements(2) <= (others => '0');
                                elements(3) <= (others => '0');
                                elements(4) <= (others => '0');
                                elements(5) <= (others => '0');
                                elements(6) <= (others => '0');
                                elements(7) <= (others => '0');
                                elements(8) <= (others => '0');
                                elements(9) <= (others => '0');
                                elements(10) <= (others => '0');
                                elements(11) <= (others => '0');
                                elements(12) <= (others => '0');
                                elements(13) <= (others => '0');
                                elements(14) <= (others => '0');
                                elements(15) <= (others => '0');
                               
--                            end loop;
--                        end loop;
            elsif  rising_edge(clk) then
--                        state <= LOAD_INPUT;
--                case state is
--                    when IDLE =>
--                        state <= LOAD_INPUT;
--                    when LOAD_INPUT =>
--                        elements(0,0) <= sub_i(127 downto 120);
--                        elements(0,1) <= sub_i(119 downto 112);
--                        elements(0,2) <= sub_i(111 downto 104);
--                        elements(0,3) <= sub_i(103 downto 96);
--                        elements(1,0) <= sub_i(95 downto 88);
--                        elements(1,1) <= sub_i(87 downto 80);
--                        elements(1,2) <= sub_i(79 downto 72);
--                        elements(1,3) <= sub_i(71 downto 64);
--                        elements(2,0) <= sub_i(63 downto 56);
--                        elements(2,1) <= sub_i(55 downto 48);
--                        elements(2,2) <= sub_i(47 downto 40);
--                        elements(2,3) <= sub_i(39 downto 32);
--                        elements(3,0) <= sub_i(31 downto 24);
--                        elements(3,1) <= sub_i(23 downto 16);
--                        elements(3,2) <= sub_i(15 downto 8);
--                        elements(3,3) <= sub_i(7 downto 0);
--                        state <= SUB_BYTES;
--                    when SUB_BYTES =>
--                        for i in 0 to 3 loop
--                            for j in 0 to 3 loop
--                                elements(i, j) <= sbox(to_integer(unsigned(elements(i, j))));
--                            end loop;
--                        end loop;
--                       state <= OUTPUT_RESULT;
--                    when OUTPUT_RESULT =>
                                elements(0) <= sbox(to_integer(unsigned(sub_i(127 downto 120))));
                                elements(1) <= sbox(to_integer(unsigned(sub_i(119 downto 112))));
                                elements(2) <= sbox(to_integer(unsigned(sub_i(111 downto 104))));
                                elements(3) <= sbox(to_integer(unsigned(sub_i(103 downto 96))));
                                elements(4) <= sbox(to_integer(unsigned(sub_i(95 downto 88))));
                                elements(5) <= sbox(to_integer(unsigned(sub_i(87 downto 80))));
                                elements(6) <= sbox(to_integer(unsigned(sub_i(79 downto 72))));
                                elements(7) <= sbox(to_integer(unsigned(sub_i(71 downto 64))));
                                elements(8) <= sbox(to_integer(unsigned(sub_i(63 downto 56))));
                                elements(9) <= sbox(to_integer(unsigned(sub_i(55 downto 48))));
                                elements(10) <= sbox(to_integer(unsigned(sub_i(47 downto 40))));
                                elements(11) <= sbox(to_integer(unsigned(sub_i(39 downto 32))));
                                elements(12) <= sbox(to_integer(unsigned(sub_i(31 downto 24))));
                                elements(13) <= sbox(to_integer(unsigned(sub_i(23 downto 16))));
                                elements(14) <= sbox(to_integer(unsigned(sub_i(15 downto 8))));
                                elements(15) <= sbox(to_integer(unsigned(sub_i(7 downto 0))));
                               
                               

                        sub_o <= elements(0) & elements(1) & elements(2) & elements(3) &
                                 elements(4) & elements(5) & elements(6) & elements(7) &
                                 elements(8) & elements(9) & elements(10) & elements(11) &
                                 elements(12) & elements(13) & elements(14) & elements(15);
--                        state <= IDLE;
--                end case;
            end if;
        end process;
    end Behavioral;
    
