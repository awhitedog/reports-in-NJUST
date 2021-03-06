LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY div48 IS
  PORT(clk:IN std_logic;
       clr:IN std_logic;
       cp: BUFFER std_logic);
END div48;

ARCHITECTURE one OF div48 IS
SIGNAL n:integer range 0 to 23;
  BEGIN
   PROCESS(clr,clk)
     BEGIN
      IF clr='0' THEN
       cp<='0';
       ELSIF(clk'event AND clk='1') THEN
           n<=n+1;
        IF n=23 THEN
            cp<=(NOT cp);
            n<=0;
        END IF;
      END IF;
   END PROCESS;
END one;
   