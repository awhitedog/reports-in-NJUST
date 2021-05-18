library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
ENTITY mo8 IS 
 PORT
(
en  :IN  std_logic;
clk  :IN  std_logic;
q :buffer std_logic_vector(2 downto 0)
);
END mo8;
ARCHITECTURE beh OF mo8 IS
BEGIN
PROCESS(clk)
BEGIN
IF(clk'EVENT and clk='1')THEN
if(en='1')then
q<=q+1;
end if;
end if;
END PROCESS;
END beh;