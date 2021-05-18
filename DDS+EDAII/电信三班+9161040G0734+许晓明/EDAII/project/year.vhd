library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
ENTITY year IS 
 PORT
(
clear:IN  std_logic;
clk :IN  std_logic;
run :OUT  std_logic;
r :buffer  std_logic_vector(1 downto 0);
y1 :buffer std_logic_vector(3 downto 0);
y2 :buffer std_logic_vector(3 downto 0);
y3 :buffer std_logic_vector(3 downto 0);
y4 :buffer std_logic_vector(3 downto 0);
en :IN  std_logic
);
END year;
ARCHITECTURE beh OF year IS
BEGIN
PROCESS(clk,clear)
BEGIN

IF(clk'EVENT and clk='1')THEN
IF(clear='0')THEN
y1<="0000";y2<="0000";y3<="0000";y4<="0000";r<="00";
else
if(en='1')then
if(y4=9)then
y4<="0000";y3<=y3+1;
else if(y3=9)then
y3<="0000";y2<=y2+1;
else if(y2=9)then
y2<="0000";y1<=y1+1;
else if(y1=9)then
y1<="0000";
else y4<=y4+1;
end if;
end if;
end if;
end if;
if(r=3)then
run<='1';r<="00";
else r<=r+1;run<='0';
end if;
end IF;
end if;
end if;
END PROCESS;
END beh;