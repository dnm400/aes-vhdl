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


signal psignal, ksignal, c0, ciphercount, keycount, clastadd, pmux, kmux, c_index, k_index, sub_o, shift_o, update_o: STD_LOGIC_VECTOR (127 downto 0):= (others => '0');
signal roundc: integer range 0 to 10 := 0;
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
        roundc <= 0;
        Rcont <= Rcon(0);
    elsif rising_edge(clockk) then
       if roundc < 10 then
         if roundc = 0 then
            psignal <= pall_i;
            ksignal <= keyall_i;
          end if;
         roundc <= roundc + 1;
         Rcont <= Rcon(roundc);
       elsif roundc = 10 then
         cipherall_o <= clastadd;
       end if;
    end if;
end process;

process(roundc)
begin
   if roundc = 0 then
      pmux <= pall_i;
    else
      pmux <= c_index;
    end if;
    if roundc = 0 then
      kmux <= keyall_i;
    else
      kmux <= k_index;
     end if;
end process;

r0: addroundkey port map(
    ptext => psignal,
    key => ksignal,
    ctext => c0);


countedrounds: aesfunctions port map(
    plaintext => pmux ,
    key => kmux ,
    ciphertext => c_index,
    Rcont => Rcont,
    keyout => k_index 
    );
    
lastsub:
subbytes port map(
     sub_i => c_index,
     sub_o => sub_o);
     
lastshift: shiftrows port map(
    shifttext_i => sub_o,
    shifttext_o => shift_o);

lastupdate: updatecipher port map( 
    thekey => k_index,
    Rcont => Rcont,
    updatedkey => update_o);
 
 lastadd: addroundkey port map(
    ptext => shift_o,
    key => update_o,
    ctext => clastadd); 

end Behavioral;
