LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY register_10 IS 
PORT(D:IN std_logic_vector(9 DOWNTO 0);
     CLK:IN std_logic;
     Q:OUT std_logic_vector(9 DOWNTO 0));
END register_10;

ARCHITECTURE register_10_arch OF register_10 IS
BEGIN
 PROCESS(CLK)
  BEGIN
    IF(CLK'EVENT AND CLK='1') THEN
        Q<=D;
    END IF;
  END PROCESS;
END register_10_arch;
    