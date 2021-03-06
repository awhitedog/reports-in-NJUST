library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
ENTITY month IS 
 PORT
( en   :IN  std_logic;
clear:IN  std_logic;--when 0,output is always 0
clk  :IN  std_logic;
rco :out  std_logic;--jinwei output
mh :buffer std_logic_vector(3 downto 0);--shiwei output
ml :buffer std_logic_vector(3 downto 0)
);--gewei output
END month;
ARCHITECTURE beh OF month IS
BEGIN
rco<='1'when(mh="0001"and ml="0010"and en='1')else'0'; 

PROCESS(clk,clear)
BEGIN
IF(clear='0')THEN
mh<="0000";
ml<="0000";
ELSIF(clk'EVENT AND clk='1')THEN
 if(en='1')then
 if((ml=9) or (ml=2 and mh=1))then
 if(ml=2 and mh=1)then
ml<="0001";
mh<="0000";
else ml<="0000";
mh<="0001";
end if;
 else ml<=ml+1;
 end if;
  end if;
END IF;
END PROCESS;
END beh;