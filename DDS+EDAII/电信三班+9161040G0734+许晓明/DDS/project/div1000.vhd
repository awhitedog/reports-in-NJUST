LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY div1000 IS
  PORT(clk:IN std_logic;
       clr:IN std_logic;
       cp2: BUFFER std_logic);
END div1000;

ARCHITECTURE one OF div1000 IS
SIGNAL n:integer range 0 to 499;
  BEGIN
   PROCESS(clr,clk)
     BEGIN
      IF clr='0' THEN
       cp2<='0';
       ELSIF(clk'event AND clk='1') THEN
           n<=n+1;
        IF n=499 THEN
            cp2<=(NOT cp2);
            n<=0;
        END IF;
      END IF;
   END PROCESS;
END one;