library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity translate3to8 is
port(a:in std_logic_vector(2 downto 0);
y:out std_logic_vector(7 downto 0));
end translate3to8;
architecture translate of translate3to8 is
begin
process(a)
begin
case a is
when"000"=>y<="01111111";--wk
when"001"=>y<="10111111";--short line
when"010"=>y<="11011111";
when"011"=>y<="11101111";
when"100"=>y<="11110111";
when"101"=>y<="11111011";
when"110"=>y<="11111101";
when"111"=>y<="11111110";
when others=>y<="11111111";--don't chose
end case;
end process;
end translate;
