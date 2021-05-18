LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY count16 IS 
PORT(reset,clk,en:IN std_logic;
      Q:BUFFER std_logic_vector(3 DOWNTO 0));
END count16;

ARCHITECTURE count16_arch OF count16 IS 
BEGIN 
  PROCESS(reset,clk,en)
    BEGIN 
    IF en='0' THEN 
      IF reset='1' THEN Q<="0000";
         ELSIF (clk'event AND clk='1') THEN
           Q<=Q+1;
      END IF;
    END IF;
  END PROCESS;
END count16_arch;
