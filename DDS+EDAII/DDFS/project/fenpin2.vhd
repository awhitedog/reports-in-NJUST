LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY fenpin2 IS
PORT(clk:IN STD_LOGIC;
mhz:buffer STD_LOGIC;
hz1:buffer STD_LOGIC;
hz0_5:buffer STD_LOGIC;
hz2:buffer STD_LOGIC;
khz:buffer STD_LOGIC);
END fenpin2;
ARCHITECTURE beh OF fenpin2 IS
SIGNAL count:integer range 0 to 24;
SIGNAL count1:integer range 0 to 24000000;
SIGNAL count2:integer range 0 to 48000000;
SIGNAL count3:integer range 0 to 12000000;
SIGNAL count4:integer range 0 to 24000;
BEGIN
PROCESS(clk)
BEGIN
IF(clk='1')THEN
count<=count+1;
count1<=count1+1;
IF(count=23)THEN
count<=0;
mhz<=NOT mhz;
END IF;
IF(count1=23999999)THEN
count1<=0;
hz1<=NOT hz1;
END IF;
IF(count2=47999999)THEN
count2<=0;
hz0_5<=NOT hz0_5;
END IF;
IF(count3=11999999)THEN
count3<=0;
hz2<=NOT hz2;
END IF;
IF(count3=11999)THEN
count4<=0;
khz<=NOT khz;
END IF;
END IF;
END PROCESS;
END beh;
