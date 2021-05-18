LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY register_12 IS 
PORT(D:IN std_logic_vector(11 DOWNTO 0);
     CLK:IN std_logic;
     Q:OUT std_logic_vector(11 DOWNTO 0));

END register_12;

ARCHITECTURE register_12_arch OF register_12 IS
BEGIN
 PROCESS(CLK)
  BEGIN
    IF(CLK'EVENT AND CLK='1') THEN
        Q<=D;
    END IF;
  END PROCESS;
END register_12_arch;
    