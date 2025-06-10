LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY counter IS
  PORT (
    floor_value : in integer;
    ceil_value  : in integer;
    clk   : IN std_logic;
    inc   : IN std_logic;
    clr   : IN std_logic;
    z     : OUT std_logic;
    count : OUT integer
  );
END counter;

ARCHITECTURE counter_architecture OF counter IS
  SIGNAL temp_counter : integer;
BEGIN
  PROCESS
  BEGIN
    WAIT UNTIL (clk'event AND clk = '1');
    IF clr = '1' THEN
      temp_counter <= floor_value;
    ELSIF inc = '1' THEN
      IF temp_counter < ceil_value THEN
        temp_counter <= temp_counter + 1;
      END IF;
    END IF;
  END PROCESS;
z <= '1' when temp_counter = ceil_value else '0';
count <= temp_counter;

END counter_architecture;

