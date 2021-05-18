LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY div0_5 IS
  PORT(clk:IN std_logic;
       clr:IN std_logic;
       cp05: BUFFER std_logic);
END div0_5;

ARCHITECTURE hf OF div0_5 IS
  BEGIN
   PROCESS(clr,clk)
     BEGIN
      IF clr='0' THEN
       cp05<='0';
       ELSIF(clk'event AND clk='1') THEN
        IF (cp05='1') THEN
            cp05<='0';
           ELSE cp05<='1';
        END IF;
      END IF;
   END PROCESS;
END hf;