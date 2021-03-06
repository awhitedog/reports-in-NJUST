library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity yimaqi is
port(a:in std_logic_vector(3 downto 0);
y:out std_logic_vector(6 downto 0));
end yimaqi;
architecture yima of yimaqi is
begin
process(a)
begin
case a is--0 means light;1 means dark
when"0000"=>y<="1000000";
when"0001"=>y<="1111001";
when"0010"=>y<="0100100";
when"0011"=>y<="0110000";
when"0100"=>y<="0011001";
when"0101"=>y<="0010010";
when"0110"=>y<="0000010";
when"0111"=>y<="1111000";
when"1000"=>y<="0000000";
when"1001"=>y<="0010000";
when"1111"=>y<="0111111";
when others=>y<="1111111";--no words
end case;
end process;
end yima;
