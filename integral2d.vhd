library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.mylib.all;
entity integral2d is
    port (
	M,N: in integer;
        rst, clk, start: in std_logic;
	mem_w_en,mem_r_en: out std_logic;
	mem_read_data: in integer;
	mem_write_data: out integer;
	mem_address: out integer range 0 to 255;
	base_address_in, base_address_out:in integer range 0 to 255;
        done : out std_logic
    );
end integral2d;

architecture rtl of integral2d is
signal 	M_out_ld, N_out_ld, I_init_rst,J_init_rst,
	I_cal_rst,J_cal_rst,I_init_inc,J_init_inc,I_cal_inc,J_cal_inc,row_init,col_init,
	add_in_ld,add_out_ld,add_out_left_ld,add_out_above_ld,add_out_diagonal_ld,
	pixel_in_ld,pixel_out_ld,pixel_out_left_ld,pixel_out_above_ld,pixel_out_diagonal_ld,I_init_eq_N,J_init_eq_M,I_cal_eq_N,J_cal_eq_M,
	mem_data_sel: std_logic;
signal 	mem_add_sel: std_logic_vector(2 downto 0);

begin
	--controller
	control_unit: controller
	port map(
        rst => rst,clk => clk,start => start,done => done,
	
	M_out_ld => M_out_ld, N_out_ld => N_out_ld,
	I_init_rst => I_init_rst,J_init_rst => J_init_rst,
	I_cal_rst => I_cal_rst,J_cal_rst=> J_cal_rst,
	I_init_inc => i_init_inc,J_init_inc=>J_init_inc,I_cal_inc=>I_cal_inc,J_cal_inc=>j_cal_inc,

	row_init=>row_init,col_init=>col_init,

	add_in_ld=>add_in_ld,add_out_ld=>add_out_ld,add_out_left_ld=>add_out_left_ld,add_out_above_ld=>add_out_above_ld,
	add_out_diagonal_ld=>add_out_diagonal_ld,
	
	pixel_in_ld=>pixel_in_ld,pixel_out_ld=>pixel_out_ld,pixel_out_left_ld=>pixel_out_left_ld,pixel_out_above_ld=>pixel_out_above_ld,
	pixel_out_diagonal_ld=>pixel_out_diagonal_ld,

	I_init_eq_N=>I_init_eq_N,J_init_eq_M=>J_init_eq_M,I_cal_eq_N=>I_cal_eq_N,J_cal_eq_M=>J_cal_eq_M,
        mem_w_en=>mem_w_en, mem_r_en=>mem_r_en,
	mem_data_sel =>mem_data_sel,
	mem_add_sel => mem_add_sel
     	);
	--datapath
	datapath_unit : datapath
	port map(
	N => N, 
	M => M,
        rst => rst,
	clk => clk,
	M_out_ld => M_out_ld, N_out_ld => N_out_ld,
	I_init_rst => I_init_rst,J_init_rst => J_init_rst,I_cal_rst => I_cal_rst,J_cal_rst=> J_cal_rst,
	I_init_inc => i_init_inc,J_init_inc=>J_init_inc,I_cal_inc=>I_cal_inc,J_cal_inc=>j_cal_inc,
	row_init=>row_init,col_init=>col_init,
	add_in_ld=>add_in_ld,add_out_ld=>add_out_ld,add_out_left_ld=>add_out_left_ld,add_out_above_ld=>add_out_above_ld,
	add_out_diagonal_ld=>add_out_diagonal_ld,
	
	pixel_in_ld=>pixel_in_ld,pixel_out_ld=>pixel_out_ld,pixel_out_left_ld=>pixel_out_left_ld,pixel_out_above_ld=>pixel_out_above_ld,
	pixel_out_diagonal_ld=>pixel_out_diagonal_ld,

	I_init_eq_N=>I_init_eq_N,J_init_eq_M=>J_init_eq_M,I_cal_eq_N=>I_cal_eq_N,J_cal_eq_M=>J_cal_eq_M,
	mem_add_sel => mem_add_sel,
	mem_data_sel =>mem_data_sel,
        base_address_in=>base_address_in, base_address_out=>base_address_out, mem_read_data=>mem_read_data,
        mem_address => mem_address,
        mem_write_data => mem_write_data
    );
end rtl;
