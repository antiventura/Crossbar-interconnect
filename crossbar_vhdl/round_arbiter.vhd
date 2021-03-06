-- -----------------------------------------------------------------------------
-- Copyright (c) 2009 Benjamin Krill <benjamin@krll.de>
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
-- -----------------------------------------------------------------------------


-- The code below is for a simple round robin arbiter. The main code belongs to Benjamin Krill's. His code has been slightly modified. 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.DEMO_PACK.all;

entity rrarbiter is
	port (
		clk   : in    std_logic;
		reset : in    std_logic;
		req   : in    std_logic_vector(number_of_masters-1 downto 0);
		grant : out   std_logic_vector(number_of_masters-1 downto 0)
	);
end;
architecture rrarbiter of rrarbiter is
	signal grant_q  : std_logic_vector(number_of_masters-1 downto 0);
	signal pre_req  : std_logic_vector(number_of_masters-1 downto 0);
	signal sel_gnt  : std_logic_vector(number_of_masters-1 downto 0);
	signal isol_lsb : std_logic_vector(number_of_masters-1 downto 0);
	signal mask_pre : std_logic_vector(number_of_masters-1 downto 0);
	signal win      : std_logic_vector(number_of_masters-1 downto 0);
begin
	grant    <=  grant_q;
	mask_pre <=  req and not (std_logic_vector(unsigned(pre_req) - 1) or pre_req); -- Mask off previous winners
	sel_gnt  <= mask_pre and      std_logic_vector(unsigned(not(mask_pre)) + 1);       -- Select new winner
	isol_lsb <=      req and      std_logic_vector(unsigned(not(req)) + 1);            -- Isolate least significant set bit.
	win      <= sel_gnt when mask_pre /= (number_of_masters-1 downto 0 => '0')  else isol_lsb;	
	process (clk, reset)
	begin

	if reset = '0' then
		pre_req <= (others => '0');
		grant_q <= (others => '0');
	else
		if (clk'event and clk='1') then
			pre_req <= pre_req;
			if win /= (number_of_masters-1 downto 0 => '0') then
				pre_req <= win;
			end if;
			grant_q <= win;

		end if;
	end if;
	end process;

end rrarbiter;

