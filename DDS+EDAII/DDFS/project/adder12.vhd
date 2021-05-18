LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY adder12 IS 
PORT(A:IN std_logic_vector(11 DOWNTO 0);
     K:IN std_logic_vector(5 DOWNTO 0);
     S:OUT std_logic_vector(11 DOWNTO 0));

END adder12;
    
ARCHITECTURE done OF adder12 IS
 signal sum:std_logic_vector(11 downto 0);
BEGIN
  sum<=K+A;
  s<=sum;
END done;