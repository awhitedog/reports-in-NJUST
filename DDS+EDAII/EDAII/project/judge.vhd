library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
ENTITY judge IS 
 PORT
(
run :IN std_logic;
mh :IN std_logic_vector(3 downto 0);
ml :IN std_logic_vector(3 downto 0);
j :buffer std_logic_vector(1 downto 0)
);
END judge;
ARCHITECTURE beh OF judge IS
BEGIN
PROCESS(run,ml,mh)
BEGIN
IF(ml=1 or ml=3 or ml=5 or ml=7 or ml=8 or (ml=0 and mh=1) or (ml=2 and mh=1 ) )THEN
j<="11";
else if(ml=4 or ml=6 or ml=9 or (ml=1 and mh=1 ))then
j<="10";
else if((ml=2 and mh=0) and run='1')then
j<="01";
else j<="00";
end if;
end if;
end IF;
END PROCESS;
END beh;