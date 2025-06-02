LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE mylib IS
component controller is
    port (
        rst, clk, start: in std_logic;
        done : out std_logic;
	M_out_ld, N_out_ld, I_init_rst,J_init_rst,I_cal_rst,J_cal_rst,I_init_inc,J_init_inc,I_cal_inc,J_cal_inc,row_init,col_init,
	add_in_ld,add_out_ld,add_out_left_ld,add_out_above_ld,add_out_diagonal_ld,
	pixel_in_ld,pixel_out_ld,pixel_out_left_ld,pixel_out_above_ld,pixel_out_diagonal_ld: out std_logic;
	I_init_eq_N,J_init_eq_M,I_cal_eq_N,J_cal_eq_M: in std_logic;
        mem_w_en, mem_r_en : out std_logic;
	mem_data_sel : out std_logic;
	mem_add_sel: out std_logic_vector(2 downto 0)
    );
end component;

component reg is
port (
	clr, CLK: in STD_logic;
	en: in std_logic;
	d: in integer;
	q: out integer
);
end component;
component memory_block IS
    PORT (
        clk    : IN std_logic;
        we_in  : IN std_logic;
        re_in  : IN std_logic;
        addr   : IN integer RANGE 0 TO 60;  -- 25 for input + 36 for output
        d_in   : IN integer;
        d_out  : OUT integer
    );
END component;

component counter IS
  PORT (
    floor_value : in integer;
    ceil_value  : in integer;
    clk   : IN std_logic;
    inc   : IN std_logic;
    clr   : IN std_logic;
    z     : OUT std_logic;
    count : OUT integer
  );
END component;

component datapath is
    port (
	M,N: in integer range 5 to 256;
        rst, clk: in std_logic;
	M_out_ld, N_out_ld, I_init_rst,J_init_rst,I_init_inc,J_init_inc,I_cal_rst,J_cal_rst,I_cal_inc,J_cal_inc,row_init,col_init,
	add_in_ld,add_out_ld,add_out_above_ld,add_out_left_ld,add_out_diagonal_ld,
	pixel_in_ld,pixel_out_ld,pixel_out_left_ld,pixel_out_above_ld,pixel_out_diagonal_ld : in std_logic;
	I_init_eq_N,J_init_eq_M,I_cal_eq_N,J_cal_eq_M: out std_logic;
	mem_add_sel: in std_logic_vector(2 downto 0);
	mem_data_sel: in std_logic;
        base_address_in, base_address_out, mem_read_data: in integer;
        mem_address: out integer;
        mem_write_data: out integer 
    );
end component;
component integral2d is
    port (
	M,N: in integer range 5 to 256;
	rst, clk, start: in std_logic;
	mem_w_en,mem_r_en: out std_logic;
	mem_read_data: in integer;
	mem_write_data: out integer;
	mem_address: out integer range 0 to 255;
	base_address_in, base_address_out:in integer range 0 to 255;
        done : out std_logic
    );
end component;
end package;
