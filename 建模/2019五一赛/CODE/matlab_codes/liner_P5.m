clear
clc
d=25;
NUM=[3 5 27 15 ; 0 2 45 0 ; 0 0 41 9 ; 40 5 6 3 ; 1 6 36 3 ; 24 4 0 30 ; 
    12 9 25 0 ; 59 0 0 0 ; 0 8 36 0 ; 0 0 43 6 ; 36 6 6 5 ; 0 10 33 0 ; 
    45 7 1 0 ; 48 6 0 0 ; 10 10 0 33 ; 0 14 12 20 ; 33 11 1 5 ; 0 4 12 39 ; 
    0 18 0 28 ; 16 6 24 2 ; 9 19 4 11 ; 0 0 47 0 ; 0 8 0 47 ; 0 24 6 8 ; 20 21 0 0 ; ];
Prise=[19.9	23	21	16];
Profit=zeros(1,d);
for i=1:size(Profit,2)
    for j=1:size(Prise,2)
   Profit(i)=Profit(i)+NUM(i,j)*Prise(j);
    end
end
 f=-100*Profit;
 ic=ones(d,1);
 for i=1:size(ic,1)
     ic(i)=i;
 end
 A=ones(1,25);
 b=[100];
 lb=zeros(d,1);
 [x,fval]=intlinprog(f,ic,A,b,[],[],lb,[])