LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY compare is
PORT(a1,a2,a3,a4,b1,b2,b3,b4:in std_logic_vector(3 downto 0);--a is the time of real time;b is the time of naozhong
bijiao:buffer bit);
end compare;
architecture beh of compare is
signal a,b:std_logic_vector(15 downto 0);
begin
a<=a4&a3&a2&a1;
b<=b4&b3&b2&b1;
process(a,b)
begin
if (a=b)then
bijiao<='1';
else bijiao<='0';
end if;
end process;
end beh;
