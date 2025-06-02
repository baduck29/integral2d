 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.mylib.all;
entity datapath is
    port (
	-- do rong anh
	M,N: in integer range 5 to 256;
	-- reset va clock
        rst, clk: in std_logic;
	-- cac tin hieu dieu khien bo dem
	I_init_rst,J_init_rst,I_init_inc,J_init_inc,I_cal_rst,J_cal_rst,I_cal_inc,J_cal_inc,
	-- tin hieu dieu khien thanh ghi
	M_out_ld, N_out_ld, row_init,col_init,
	add_in_ld,add_out_ld,add_out_above_ld,add_out_left_ld,add_out_diagonal_ld,
	pixel_in_ld,pixel_out_ld,pixel_out_left_ld,pixel_out_above_ld,pixel_out_diagonal_ld : in std_logic;
	-- tin hieu so sanh tu bo dem
	I_init_eq_N,J_init_eq_M,I_cal_eq_N,J_cal_eq_M: out std_logic;
	-- tin hieu dieu khien gui cho memory
	mem_add_sel: in std_logic_vector(2 downto 0);
	mem_data_sel: in std_logic;
        base_address_in, base_address_out: in integer range 0 to 255;
	mem_read_data: in integer;
        mem_address: out integer range 0 to 255;
        mem_write_data: out integer 
    );
end datapath;

architecture rtl of datapath is
-- tin hieu trung gian
signal  row_init_add,col_init_add,
	I_init,J_init,I_cal,J_cal,rowt,colt,
	add_in_in, add_in_out, add_out_in, add_out_out, add_out_left_in, add_out_left_out,
	add_out_above_in, add_out_above_out, add_out_diagonal_in, add_out_diagonal_out,
	pixel_in, pixel_out_in,pixel_out_out ,pixel_out_left,pixel_out_above,pixel_out_diagonal: integer;
-- kich thuoc anh dau ra
signal M_out, M_in :integer;
signal N_out, N_in :integer;
begin 
-- khoi tao anh dau ra
    M_in <= M + 1;
    N_in <= N + 1;
-- cac thanh ghi
-- thanh ghi cho kich thuoc anh dau ra
nOutreg: reg
port map(
	clr => rst,
	CLK => clk,
	en => N_out_ld,
	d => N_in,
	q => N_out
);
mOutreg: reg
port map(
	clr => rst,
	CLK => clk,
	en => M_out_ld,
	d => M_in,
	q => M_out
);
-- thanh ghi luu dia chi cua row_init, col_init
rowt <= base_address_out + M_out * I_init;
colt <= base_address_out + J_init;
rowInitreg: reg
port map(
	clr => rst,
	CLK => clk,
	en => row_init,
	d => rowt,
	q => row_init_add
);
colInitreg: reg
port map(
	clr => rst,
	CLK => clk,
	en => col_init,
	d => colt,
	q => col_init_add
);
-- cac thanh ghi dia chi du lieu
add_in_in <= base_address_in + (I_cal - 1) * (M_out - 1) + J_cal - 1;
add_out_in <= base_address_out + I_cal * M_out + J_cal;
add_out_left_in <= base_address_out + I_cal * M_out + J_cal - 1;
add_out_above_in <= base_address_out + (I_cal - 1) * M_out + J_cal;
add_out_diagonal_in <= base_address_out + (I_cal - 1) * M_out + J_cal - 1;
addInreg: reg
port map (
	clr => rst,
	CLK => clk,
	en => add_in_ld,
	d => add_in_in,
	q => add_in_out
);
addOutreg: reg
port map (
	clr => rst,
	CLK => clk,
	en => add_out_ld,
	d => add_out_in,
	q => add_out_out
);
addOutLeftreg: reg
port map (
	clr => rst,
	CLK => clk,
	en => add_out_left_ld,
	d => add_out_left_in,
	q => add_out_left_out
);
addOutAbovereg: reg
port map (
	clr => rst,
	CLK => clk,
	en => add_out_above_ld,
	d => add_out_above_in,
	q => add_out_above_out
);
addOutDiagonalreg: reg
port map (
	clr => rst,
	CLK => clk,
	en => add_out_diagonal_ld,
	d => add_out_diagonal_in,
	q => add_out_diagonal_out
);
--cac thanh ghi luu gia tri pixel
pixelInreg: reg
port map (
	clr => rst,
	CLK => clk,
	en => pixel_in_ld,
	d => mem_read_data,
	q => pixel_in
);
pixelOutLeftreg: reg
port map (
	clr => rst,
	CLK => clk,
	en => pixel_out_left_ld,
	d => mem_read_data,
	q => pixel_out_left
);
pixelOutAbovereg: reg
port map (
	clr => rst,
	CLK => clk,
	en => pixel_out_above_ld,
	d => mem_read_data,
	q => pixel_out_above
);
pixelOutDiagonalreg: reg
port map (
	clr => rst,
	CLK => clk,
	en => pixel_out_diagonal_ld,
	d => mem_read_data,
	q => pixel_out_diagonal
);
pixel_out_in <= pixel_in + pixel_out_left + pixel_out_above - pixel_out_diagonal;
pixelOutreg: reg
port map (
	clr => rst,
	CLK => clk,
	en => pixel_out_ld,
	d => pixel_out_in,
	q => pixel_out_out
);

--bo hop kenh
mem_address <= 	row_init_add when mem_add_sel = "000" else
		col_init_add when mem_add_sel = "001" else
		add_in_out when mem_add_sel = "010" else
		add_out_out when mem_add_sel = "011" else
		add_out_left_out when mem_add_sel = "100" else
		add_out_above_out when mem_add_sel = "101" else
		add_out_diagonal_out when mem_add_sel = "110" else
		0;
mem_write_data <= pixel_out_out when mem_data_sel = '1' else 0;
--bo dem
I_initCounter : counter
  PORT map(
    floor_value => 0,
    ceil_value  => N_out,
    clk   => clk,
    inc   => I_init_inc,
    clr   => I_init_rst,
    z     => I_init_eq_N,
    count => I_init
  );
J_initCounter : counter
  PORT map(
    floor_value => 0,
    ceil_value  => M_out,
    clk   => clk,
    inc   => J_init_inc,
    clr   => J_init_rst,
    z     => J_init_eq_M,
    count => J_init
  );
I_calCounter : counter
  PORT map(
    floor_value => 1,
    ceil_value  => N_out,
    clk   => clk,
    inc   => I_cal_inc,
    clr   => I_cal_rst,
    z     => I_cal_eq_N,
    count => I_cal
  );
J_calCounter : counter
  PORT map(
    floor_value => 1,
    ceil_value  => M_out,
    clk   => clk,
    inc   => J_cal_inc,
    clr   => J_cal_rst,
    z     => J_cal_eq_M,
    count => J_cal
  );
end rtl;
