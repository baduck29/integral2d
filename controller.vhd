library IEEE;
use IEEE.STD_LOGIC_1164.ALL;	

entity controller is
    port (
        rst, clk, start: in std_logic;
        done : out std_logic;
	--tin hieu dieu khien datapath
	M_out_ld, N_out_ld, N_init,M_init,I_init_rst,J_init_rst,I_cal_rst,J_cal_rst,I_init_inc,J_init_inc,I_cal_inc,J_cal_inc,row_init,col_init,
	add_in_ld,add_out_ld,add_out_left_ld,add_out_above_ld,add_out_diagonal_ld,
	pixel_in_ld,pixel_out_ld,pixel_out_left_ld,pixel_out_above_ld,pixel_out_diagonal_ld: out std_logic;
	I_init_eq_N,J_init_eq_M,I_cal_eq_N,J_cal_eq_M: in std_logic;
	--tin hieu cho memory
        mem_w_en, mem_r_en : out std_logic;
	mem_data_sel : out std_logic;
	mem_add_sel: out std_logic_vector(2 downto 0)
    );
end controller;

architecture rtl of controller is
TYPE state_type IS (
  S1, S2, S3, S4, S5, S6, S7, S8, S9, S10,
  S11, S12, S13, S14, S15, S16, S17, S18, S19, S20,
  S21, S22, S23, S24,s24a, S25,s25a, S26,s26a, S27,s27a, S28, S29, S30,
  S31, S32, S33, S34
);
SIGNAL state : state_type;
begin 
process(clk,rst,state)
begin
if(rst = '1') then state <= s1;
elsif clk'event and clk = '1' then
	case state is
	when s1 => 
	state <= s2;
	when s2 => 
	if start = '1' then state <= s3;
	else state <= s2;
	end if;
	when s3 => 
	state <= s4;
	when s4 => 
	state <= s5;	
	when s5 => 
	state <= s6;	
	when s6 => 
	if I_init_eq_N = '1' then state <= s10;
	else state <= s7;
	end if;
	when s7 => 
	state <= s8;
	when s8 => 
	state <= s9;
	when s9 => 
	state <= s6;
	when s10 => 
	state <= s11;		
	when s11 => 
	if J_init_eq_M = '1' then state <= s15;
	else state <= s12;
	end if;
	when s12 => 
	state <= s13;
	when s13 => 
	state <= s14;
	when s14 => 
	state <= s11;
	when s15 => 
	state <= s16;
	when s16 => 
	if I_cal_eq_N = '1' then state <= s32;
	else state <= s17;
	end if;
	when s17 => 
	state <= s18;
	when s18 => 
	if J_cal_eq_M = '1' then state <= s31;
	else state <= s19;
	end if;
	when s19 => 
	state <= s20;
	when s20 => 
	state <= s21;
	when s21 => 
	state <= s22;
	when s22 => 
	state <= s23;
	when s23 => 
	state <= s24;
	when s24 => 
	state <= s24a;
	when s24a =>
	state <= s25;
	when s25 => 
	state <= s25a;
	when s25a =>
	state <= s26;
	when s26 => 
	state <= s26a;
	when s26a =>
	state <= s27;
	when s27 => 
	state <= s27a;
	when s27a =>
	state <= s28;
	when s28 => 
	state <= s29;
	when s29 => 
	state <= s30;
	when s30 =>
	state <= s18;
	when s31 =>
	state <= s16;
	when s32 => 
	state <= s33;
	when s33 => 
	state <= s34;
	when s34 => 
	state <= s1;		
	when others =>
	state <= s1;				
end case;
end if;
end process;

--logic to hop

--cac tin hieu cho register
N_out_ld <= '1' when state = s3 else '0';
M_out_ld <= '1' when state = s4 else '0';
row_init <= '1' when state = s7 else '0';
col_init <= '1' when state = s12 else '0';
add_in_ld <= '1' when state = s19 else '0';
add_out_ld <= '1' when state = s20 else '0';
add_out_left_ld <= '1' when state = s21 else '0';
add_out_above_ld <= '1' when state = s22 else '0';
add_out_diagonal_ld <= '1' when state = s23 else '0';
pixel_in_ld <= '1' when state = s24a else '0';
pixel_out_left_ld <= '1' when state = s25a else '0';
pixel_out_above_ld <= '1' when state = s26a else '0';
pixel_out_diagonal_ld <= '1' when state = s27a else '0';
pixel_out_ld <= '1' when state = s28 else '0';

--tin hieu cho counter
I_init_rst <= '1' when state = s5 or state = s1 else '0';
J_init_rst <= '1' when state = s10 or state = s1 else '0';
I_init_inc <= '1' when state = s9 else '0';
J_init_inc <= '1' when state = s14 else '0';
I_cal_rst <= '1' when state = s15 or state = s1 else '0';
J_cal_rst <= '1' when state = s17 or state = s1 else '0';
I_cal_inc <= '1' when state = s31 else '0';
J_cal_inc <= '1' when state = s30 else '0';

--tin hieu cho memory
mem_w_en <= '1' when (state = s8 or state = s13 or state = s29) else '0';
mem_r_en <= '1' when (state = s24 or state = s25 or state = s26 or state = s27) else '0';
mem_add_sel <= "000" when state = s8 else
		"001" when state = s13 else
		"010" when state = s24 else
		"011" when state = s29 else
		"100" when state = s25 else
		"101" when state = s26 else
		"110" when state = s27 else
		"111";
mem_data_sel <= '1' when state = s29 else '0';
done <= '1' when state = s32 else '0';
end rtl;