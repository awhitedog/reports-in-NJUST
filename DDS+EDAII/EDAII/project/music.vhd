library ieee;
use ieee.std_logic_1164.all;
ENTITY music IS
PORT(
clk : in std_logic;
beep: out std_logic
);
end music;
architecture beh of music is
type state_type is (do_l,re_l,mi_l,fa_l,sol_l,la_l,si_l,do_m,re_m,mi_m,fa_m,sol_m,la_m,si_m,do_h,re_h,mi_h,fa_h,sol_h,la_h,si_h,none);
signal counter : integer range 0 to 100000 := 0; 
signal count : integer range 0 to 99 := 0; 
signal beep_reg: std_logic;
signal clk1khz,clk4hz : std_logic;
signal note : state_type ;
begin
beep <= beep_reg;
beep_pro : process(clk)
variable cnt : integer range 0 to 100000 := 0;
begin
if clk'event and clk='1' then
if cnt < counter then
cnt := cnt + 1 ;
else
cnt := 0 ; beep_reg <= not beep_reg;
end if;
end if;
end process beep_pro;
clk1khz_pro : process(clk) 
variable cnt : integer range 0 to 23999;
begin
if clk'event and clk='1' then
if cnt = 23999 then
cnt := 0 ; clk1khz <= not clk1khz;
else 
cnt := cnt + 1;
end if;
end if;
end process clk1khz_pro;
clk4hz_pro :process(clk1khz) 
variable cnt : integer range 0 to 124 := 0;
begin
if clk1khz'event and clk1khz = '1' then
if cnt = 124 then
cnt := 0 ; clk4hz <= not clk4hz;
else
cnt := cnt + 1;
end if;
end if;
end process clk4hz_pro;
count_pro : process(clk4hz) 
begin
if clk4hz'event and clk4hz ='1' then
if count <= 66 then
count <= count + 1;
else
count <= 0;
end if;
end if;
end process count_pro;
note_pro : process(note)
begin
case note is
when do_l => counter <= 91742 ;
when re_l => counter <= 81715 ;
when mi_l => counter <= 72814 ;
when fa_l => counter <= 68727 ;
when sol_l => counter <=61223 ;
when la_l => counter <= 54544 ;
when si_l => counter <= 48592 ;
when do_m => counter <= 45861 ;
when re_m => counter <= 40864 ;
when mi_m => counter <= 36401 ;
when fa_m => counter <= 34358 ;
when sol_m => counter <=30611 ;
when la_m => counter <= 27271 ;
when si_m => counter <= 24295 ; 
when do_h => counter <= 22932 ;
when re_h => counter <= 20429 ;
when mi_h => counter <= 18201 ;
when fa_h => counter <= 17183 ;
when sol_h => counter <=15305 ;
when la_h => counter <= 13635 ;
when si_h => counter <= 12148 ;
when others => counter <= 0;
end case;
end process note_pro;
music_pro : process(count) 
begin
case count is when 0 => note <= do_m ;
when 1 => note <= do_m;
when 3 => note <= re_m;
when 5 => note <= mi_m;
when 7 => note <= do_m;
when 9 => note <= do_m;
when 11 => note <= re_m;
when 13 => note <= mi_m;
when 15 => note <= do_m;
when 17 => note <= mi_m;
when 19 => note <= fa_m;
when 21 => note <= sol_m;
when 22 => note <= sol_m;
when 23 => note <= sol_m;
when 25 => note <= mi_m;
when 27 => note <= fa_m;
when 29 => note <= sol_m;
when 30 => note <= sol_m;
when 31 => note <= sol_m ;
when 33 => note <= sol_m ;
when 34 => note <= la_m ;
when 35 => note <= sol_m ;
when 36 => note <= fa_m ;
when 37 => note <= mi_m ;
when 38 => note <= mi_m ;
when 39 => note <= do_m ;
when 40 => note <= do_m ;
when 41 => note <= sol_m;
when 42 => note <= la_m;
when 43 => note <= sol_m;
when 44 => note <= fa_m;
when 45 => note <= mi_m;
when 46 => note <= mi_m;
when 47 => note <= do_m;
when 48 => note <= do_m;
when 49 => note <= re_m;
when 50 => note <= re_m;
when 51 => note <= sol_l;
when 52 => note <= sol_l;
when 53 => note <= do_m ;
when 54 => note <= do_m ;
when 55 => note <= do_m ;
when 57 => note <= re_m;
when 58 => note <= re_m;
when 59 => note <= sol_l;
when 60 => note <= sol_l;
when 61 => note <= do_m;
when 62 => note <= do_m;
when 63 => note <= do_m;
when others => note <= none;
end case;
end process music_pro;
end beh;
