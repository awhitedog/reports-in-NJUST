library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
ENTITY mo24 IS 
 PORT
( en   :IN  std_logic;
clear:IN  std_logic;--when 0,output is always 0
clk  :IN  std_logic;
cout :out  std_logic;--jinwei output
qh :buffer std_logic_vector(3 downto 0);--shiwei output
ql :buffer std_logic_vector(3 downto 0)
);--gewei output
END mo24;
ARCHITECTURE beh OF mo24 IS
BEGIN
cout<='1'when(qh="0010"and ql="0011"and en='1')else'0'; 

PROCESS(clk,clear)
BEGIN
IF(clear='0')THEN
qh<="0000";
ql<="0000";
ELSIF(clk'EVENT AND clk='1')THEN
if(en='1')then
if((ql=3 and qh=2) or ql=9) then
ql<="0000";
if(qh=2)then
qh<="0000";
else
qh<=qh+1;
end if;
else
ql<=ql+1;
end if;
end if;
END IF;
END PROCESS;
END beh;