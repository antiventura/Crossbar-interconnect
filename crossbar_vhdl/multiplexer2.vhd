library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.DEMO_PACK.all;


entity mux_2to1_top2 is
    Port ( SEL : in  STD_LOGIC;
           A   : in  std_logic_vector(number_of_masters-1 downto 0);
           B   : in  std_logic_vector(number_of_masters-1 downto 0);
           X   : out std_logic_vector(number_of_masters-1 downto 0)
	);
end mux_2to1_top2;

architecture Behavioral of mux_2to1_top2 is
begin
    X <= A when (SEL = '0') else B;
end Behavioral;











