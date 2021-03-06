library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
ENTITY mmo40 IS 
 PORT
    ( en   :IN  std_logic;
      clear:IN  std_logic;
      clk  :IN  std_logic;
      cout :out  std_logic;
      qh   :buffer std_logic_vector(3 downto 0);
      ql   :buffer std_logic_vector(3 downto 0)
    );
END mmo40;
ARCHITECTURE behave OF mmo40 IS
BEGIN
cout<='1'when(qh="0011"and ql="1001"and en='0')else'0'; 

   PROCESS(clk,clear)
     BEGIN
       IF(clear='1')THEN
                qh<="0000";
                ql<="0000";
              ELSIF(clk'EVENT AND clk='1')THEN
                 if(en='0')then
                          if((ql=9 and qh=3) or ql=9) then
                                ql<="0000";
                               if(qh=3)then
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
           END behave;
