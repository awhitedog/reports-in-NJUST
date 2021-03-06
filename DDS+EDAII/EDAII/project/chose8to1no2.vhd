library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity chose8to1no2 is
port(y3,y4,mh,ml,dh,dl:in std_logic_vector(3 downto 0);
sel:in std_logic_vector(2 downto 0);
q:out std_logic_vector(3 downto 0)); 
end chose8to1no2;
architecture chose of chose8to1no2 is
begin
process(sel,y3,y4,mh,ml,dh,dl)
begin
case sel is
when"000"=>q<=y3;
when"001"=>q<=y4;
when"010"=>q<="1111";
when"011"=>q<=mh;
when"100"=>q<=ml;
when"101"=>q<="1111";
when"110"=>q<=dh;
when"111"=>q<=dl;
when others=>q<="0000";
end case;
end process;
end chose;
