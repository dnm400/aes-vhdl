----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.07.2024 09:40:33
-- Design Name: 
-- Module Name: aesfaster - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity aesfaster is
   Port (
    clockk : std_logic;
    resett : std_logic;
    pall_i : in STD_LOGIC_VECTOR (127 downto 0);
    keyall_i: in STD_LOGIC_VECTOR (127 downto 0);
    cipherall_o : out STD_LOGIC_VECTOR (127 downto 0) );
end aesfaster;

architecture Behavioral of aesfaster is

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


signal psignal, ksignal, c0, clastadd, pmux, kmux, c_index, k_index, sub_o, shift_o, update_o: STD_LOGIC_VECTOR (127 downto 0):= (others => '0');
signal roundc: integer range -1 to 10 := -1;
signal Rcont: std_logic_vector(31 downto 0):= (others => '0');
component aesfunctions is
Port(
   plaintext : in STD_LOGIC_VECTOR (127 downto 0);
   key: in STD_LOGIC_VECTOR (127 downto 0);
   ciphertext : out STD_LOGIC_VECTOR (127 downto 0);
   RCont : in STD_LOGIC_VECTOR(31 downto 0);
   keyout: out STD_LOGIC_VECTOR (127 downto 0)
    );
end component;

component subbytes is
Port (
    sub_i : in STD_LOGIC_VECTOR (127 downto 0);
    sub_o : out STD_LOGIC_VECTOR (127 downto 0)   
    );
end component;

component shiftrows is
Port (
   shifttext_i : in STD_LOGIC_VECTOR (127 downto 0);
   shifttext_o : out STD_LOGIC_VECTOR (127 downto 0)
   );
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


begin
process(clockk, resett)
begin

    if resett = '1' then
        psignal <= (others => '0');
        ksignal <= (others => '0');
        cipherall_o <= (others => '0') ;
        roundc <= -1;
        Rcont <= Rcon(0);
        
    elsif rising_edge(clockk) then
       if roundc < 10 then
         if roundc = -1 then
            psignal <= pall_i;
            ksignal <= keyall_i; 
            pmux <= pall_i;
            kmux <= keyall_i;
            cipherall_o <= pall_i;
         elsif roundc = 0 then
            pmux <= c0;
            kmux <= keyall_i;
            cipherall_o <= c0;
         else 
            pmux <= c_index;
            kmux <= k_index;
            cipherall_o <= c_index;
         end if; 
         roundc <= roundc + 1;
         if roundc >= 0 then
            Rcont <= Rcon(roundc);
         end if;
       elsif roundc = 10 then
         cipherall_o <= clastadd;
       end if;
    end if;
end process;

--process(clockk)
--begin
--   if rising_edge(clockk) then
--    if roundc = -1 then
--          pmux <= pall_i;
--          kmux <= keyall_i;         
--    elsif roundc < 10 then
--      if roundc = 0 then
--          pmux <= c0;
--          kmux <= keyall_i;    
--      else  
--          pmux <= c_index;
--          kmux <= k_index;
--      end if;
--    end if;
--   end if;
--end process;
        
r0: addroundkey port map(
    ptext => psignal,
    key => ksignal,
    ctext => c0);

--pmux <= (others => '0') when roundc = 0 else
--        c0 when roundc = 1 else
--        c_index ;
        
--kmux <= (others => '0') when roundc = 0 else
--        ksignal when roundc = 1 else
--        k_index;
        
countedrounds: aesfunctions port map(
    plaintext => pmux ,
    key => kmux ,
    ciphertext => c_index,
    Rcont => Rcont,
    keyout => k_index 
    );
    
lastsub:
subbytes port map(
     sub_i => pmux,
     sub_o => sub_o);
     
lastshift: shiftrows port map(
    shifttext_i => sub_o,
    shifttext_o => shift_o);

lastupdate: updatecipher port map( 
    thekey => kmux,
    Rcont => Rcont,
    updatedkey => update_o);
 
lastadd: addroundkey port map(
    ptext => shift_o,
    key => update_o,
    ctext => clastadd); 

end Behavioral;
