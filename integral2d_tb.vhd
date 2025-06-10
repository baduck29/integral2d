library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.mylib.all;

entity integral2d_tb is
end integral2d_tb;

architecture tb of integral2d_tb is
constant clk_period : time := 50 ns;
constant N: integer := 5;
constant M: integer := 5;

signal clk : std_logic := '0';
signal start,rst,done : std_logic;
signal mem_address,mem_read_data,mem_write_data: integer;
signal mem_w_en,mem_r_en: std_logic;
signal base_address_in: integer range 0 to 24;
constant base_address_out_max : integer := ((N*M)+((N+1)*(M+1)) - 1);
signal base_address_out : integer range 25 to base_address_out_max;
begin

	clk <= not clk after clk_period;

	integral2d_unit : integral2d
	--generic map()
    	port map(
	M => M,
	N => N,
        rst => rst,
	clk => clk, 
	start => start,
	mem_w_en => mem_w_en,
	mem_r_en => mem_r_en,
	mem_read_data => mem_read_data,
	mem_write_data => mem_write_data,
	mem_address => mem_address,
	base_address_in=> base_address_in, 
	base_address_out=>base_address_out,
        done => done
    	);
	memory_unit : memory_block
	port map(
	clk    => clk,
        we_in  => mem_w_en,
        re_in  => mem_r_en,
        addr   => mem_address,
        d_in   => mem_write_data,
        d_out  => mem_read_data
	);
testing: process
begin	
	base_address_in <= 0;
    	base_address_out <= 25;
	rst <= '1';
	wait for 3 *clk_period;
	rst <= '0';
	start <= '1';
	wait until done = '1';
    	wait for clk_period;
	wait;
end process; 
end tb;