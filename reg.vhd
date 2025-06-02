library IEEE;
use ieee.std_logic_1164.all;

entity reg is
port (
	clr, CLK: in STD_logic;
	en: in std_logic;
	d: in integer;
	q: out integer
);
end reg;

architecture rtl of reg is

begin
	process(clr,clk)
	begin
		if (clr = '1') then
			q <= 0;
		elsif (clk'event and clk = '1') then
			if(en = '1') then
				q <= d;
			end if; 	
		end if;
	end process;
end architecture rtl;