library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
ENTITY mo7 IS 
 PORT
( en   :IN  std_logic;
clear:IN  std_logic;--when 0,output is always 0
clk  :IN  std_logic;
ql :buffer std_logic_vector(3 downto 0)
);
END mo7;
ARCHITECTURE beh OF mo7 IS
BEGIN
PROCESS(clk,clear)
BEGIN
IF(clear='0')THEN
ql<="0000";
ELSIF(clk'EVENT AND clk='1')THEN
if(en='1')then
if(ql=7) then
ql<="0001";
else
ql<=ql+1;
end if;
end if;
END IF;
END PROCESS;
END beh;