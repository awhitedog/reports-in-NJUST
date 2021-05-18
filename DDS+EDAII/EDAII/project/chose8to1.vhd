library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity chose8to1 is
port(wl,hh,hl,fh,fl,mh,ml:in std_logic_vector(3 downto 0);
sel:in std_logic_vector(2 downto 0);
q:out std_logic_vector(3 downto 0)); 
end chose8to1;
architecture chose of chose8to1 is
begin
process(sel,wl,hh,hl,fh,fl,mh,ml)
begin
case sel is
when"000"=>q<=wl;--week
when"001"=>q<="1111";--short line,to devide week and times
when"010"=>q<=hh;--shiwei of hour
when"011"=>q<=hl;--gewei of hour
when"100"=>q<=fh;--shiwei of minite
when"101"=>q<=fl;--gewei of minite
when"110"=>q<=mh;--shiwei of seconds
when"111"=>q<=ml;--gewei of seconds
when others=>q<="0000";-- don't care
end case;
end process;
end chose;
