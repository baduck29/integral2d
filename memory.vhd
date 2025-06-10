LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY memory_block IS
    PORT (
        clk    : IN std_logic;
        we_in  : IN std_logic;
        re_in  : IN std_logic;
        addr   : IN integer RANGE 0 TO 60;  --25 cho in + 36 cho out
        d_in   : IN integer;
        d_out  : OUT integer
    );
END memory_block;

ARCHITECTURE behavior OF memory_block IS
    TYPE DATA_ARRAY IS ARRAY(0 TO 60) OF integer;
    SIGNAL memory : DATA_ARRAY := (
        -- Input image 5x5: values 1 to 25
        17, 24, 1, 8, 15,
        23, 5, 7, 14, 16,
        4, 6, 13, 20, 22,
	10, 12, 19, 21, 3,
	11, 18, 25, 2, 9,
        -- Output image 6x6: initialized to 0
        0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0
    );
BEGIN
PROCESS(clk)
BEGIN
    IF rising_edge(clk) THEN
        IF we_in = '1' THEN
            memory(addr) <= d_in;
        END IF;
        IF re_in = '1' THEN
            d_out <= memory(addr);
        ELSE
            d_out <= 0;  --out = 0 neu khong co tin hieu.
        END IF;
    END IF;
END PROCESS;
END behavior;
