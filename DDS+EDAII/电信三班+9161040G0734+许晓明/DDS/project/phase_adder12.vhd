LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY phase_adder12 IS 
PORT(A:IN std_logic_vector(11 DOWNTO 0);
     P:IN std_logic_vector(11 DOWNTO 8);
     S:OUT std_logic_vector(11 DOWNTO 0));

END phase_adder12;
    
ARCHITECTURE done OF phase_adder12 IS
BEGIN
 PROCESS(A,P)
   VARIABLE B:STD_LOGIC_VECTOR(7 DOWNTO 0);
   VARIABLE C:STD_LOGIC_VECTOR(11 DOWNTO 0);
 BEGIN
   B:="00000000";
   C:=P&B;
   S<=C+A;
 END PROCESS;
END done;

   
