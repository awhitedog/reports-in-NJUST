library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
ENTITY day IS 
 PORT
(
clear:IN  std_logic;
judge :IN std_logic_vector(1 downto 0);--judge how many days
clk :IN  std_logic;
dh :buffer std_logic_vector(3 downto 0);
dl :buffer std_logic_vector(3 downto 0);
rco : OUT std_logic;
 en   :IN  std_logic
);
END day;
ARCHITECTURE beh OF day IS
BEGIN
PROCESS(clk,judge,clear)
BEGIN
IF(clk'EVENT and clk='1')THEN
IF(en='1')then
IF(clear='0')THEN
dh<="0000";dl<="0000";
else
case judge is
when"00"=>--28
if(dh=2 and dl=8)then
rco<='1';dh<="0000";dl<="0001";
else if(dl=9)then
dh<=dh+1;dl<="0000";rco<='0';
else rco<='0';dl<=dl+1;
end if;
end if;
when"01"=>--29
if(dh=2 and dl=9)then
rco<='1';dh<="0000";dl<="0001";
else if(dl=9)then
dh<=dh+1;dl<="0000";rco<='0';
else rco<='0';dl<=dl+1;
end if;
end if;
when"10"=>--30
if(dh=3 and dl=0)then
rco<='1';dh<="0000";dl<="0001";
else if(dl=9)then
dh<=dh+1;dl<="0000";rco<='0';
else rco<='0';dl<=dl+1;
end if;
end if;
when others =>--31
if(dh=3 and dl=1)then
rco<='1';dh<="0000";dl<="0001";
else if(dl=9)then
dh<=dh+1;dl<="0000";rco<='0';
else rco<='0';dl<=dl+1;
end if;
end if;
end case;
end if;
end IF;
end if;
END PROCESS;
END beh;