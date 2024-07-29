----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.07.2024 14:12:17
-- Design Name: 
-- Module Name: allrounds - Behavioral
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

entity allrounds is
Port (  clockk    :   in STD_LOGIC;      
        resett    : in STD_LOGIC;
    --pall_i : in STD_LOGIC_VECTOR (127 downto 0);
   --keyall_i: in STD_LOGIC_VECTOR (127 downto 0);
    cipherall_o : out STD_LOGIC_VECTOR (127 downto 0)
    );
end allrounds;

architecture Behavioral of allrounds is

constant pall_i: STD_LOGIC_VECTOR(127 DOWNTO 0):= x"3243f6a8885a308d313198a2e0370734";
constant keyall_i: STD_LOGIC_VECTOR(127 DOWNTO 0):=   x"2b7e151628aed2a6abf7158809cf4f3c";

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

component addroundkey is
Port (clk    : in STD_LOGIC;
    rst    : in STD_LOGIC;
    ptext : in STD_LOGIC_VECTOR (127 downto 0);
    key: in STD_LOGIC_VECTOR (127 downto 0);
    ctext : out STD_LOGIC_VECTOR (127 downto 0)  );
end component;

component updatecipher is
Port (clk    : in STD_LOGIC;
    rst    : in STD_LOGIC;
    thekey : in STD_LOGIC_VECTOR(127 downto 0);
    RCont : in STD_LOGIC_VECTOR(31 downto 0);
    updatedkey  : out STD_LOGIC_VECTOR(127 downto 0)
     );
end component;

component aesfunctions is 
Port (  
    clkfn    : in STD_LOGIC;
    rstfn  : in STD_LOGIC;
    plaintext : in STD_LOGIC_VECTOR (127 downto 0);
    key: in STD_LOGIC_VECTOR (127 downto 0);
    ciphertext : out STD_LOGIC_VECTOR (127 downto 0);
    RCont : in STD_LOGIC_VECTOR(31 downto 0);
    keyout: out STD_LOGIC_VECTOR (127 downto 0)

    );
end component;

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

signal c0, c1,c2,c3,c4,c5,c6,c7,c8, c9, k1, k2,k3, k4, k5, k6, k7, k8, k9, sub10_o, shift10_o, update10_o  : STD_LOGIC_VECTOR (127 downto 0):= x"00000000000000000000000000000000";
type ninerounds is array (1 to 10) of std_logic_vector(127 downto 0);
signal p_o, k_o: ninerounds; 
begin 

r0: addroundkey port map(
    clk => clockk ,
    rst => resett,
    ptext => pall_i,
    key => keyall_i,
    ctext => c0);
    
r1: aesfunctions port map(
    clkfn => clockk ,
     rstfn => resett,
    plaintext => c0 ,
    key => keyall_i ,
    ciphertext => c1,
    Rcont => Rcon(0),
    keyout =>k1 
    );
    
r2: aesfunctions port map(
    clkfn => clockk ,
     rstfn => resett,
    plaintext =>c1 ,
    key =>k1 ,
    ciphertext => c2,
    Rcont => Rcon(1) ,
    keyout =>k2
     );    

r3: aesfunctions port map(
    clkfn => clockk ,
     rstfn => resett,
    plaintext => c2,
    key =>k2 ,
    ciphertext => c3 ,
    Rcont => Rcon(2) ,
    keyout =>k3
    );
    
r4: aesfunctions port map(
    clkfn => clockk ,
     rstfn => resett,
    plaintext => c3,
    key =>k3 ,
    ciphertext => c4 ,
    Rcont => Rcon(3),
    keyout =>k4
    );
    
r5: aesfunctions port map(
    clkfn => clockk ,
     rstfn => resett,
    plaintext =>c4 ,
    key =>k4 ,
    ciphertext => c5 ,
    Rcont => Rcon(4) ,
    keyout =>k5
    );
    
r6: aesfunctions port map(
    clkfn => clockk ,
     rstfn => resett,
    plaintext =>c5 ,
    key => k5,
    ciphertext => c6,
    Rcont => Rcon(5) ,
    keyout =>k6
    );
    
r7: aesfunctions port map(
    clkfn => clockk ,
     rstfn => resett,
    plaintext =>c6 ,
    key =>k6 ,
    ciphertext => c7 ,
    Rcont => Rcon(6) ,
    keyout =>k7
    );
    
r8: aesfunctions port map(
    clkfn => clockk ,
    rstfn => resett,
    plaintext => c7,
    key => k7,
    ciphertext => c8,
    Rcont => Rcon(7),
    keyout =>k8
    );
  
r9: aesfunctions port map(
    clkfn => clockk ,
     rstfn => resett,
    plaintext =>c8 ,
    key =>k8 ,
    ciphertext => c9,
    Rcont => Rcon(8),
    keyout =>k9
    );
    
r10_sub: subbytes port map(
     clk => clockk ,
     rst => resett,
     sub_i => c9,
     sub_o => sub10_o);

r10_shift: shiftrows port map(
    clk => clockk ,
    rst => resett,
    shifttext_i => sub10_o,
    shifttext_o => shift10_o);

r10_update: updatecipher port map(
    clk => clockk ,
    rst => resett,
    thekey => k_o(9),
    Rcont => Rcon(9),
    updatedkey => update10_o);
 
 r10_add: addroundkey port map(
    clk => clockk ,
    rst => resett,
    ptext => shift10_o,
    key => update10_o,
    ctext => cipherall_o);


end Behavioral;
