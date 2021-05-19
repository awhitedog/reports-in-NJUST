clear
clc
f=[1 1 1 1 1 1 1];
ic=[1 2 3 4 5 6 7 ];
A=-1*[44 35 32 0 59 45 16;12 19 21 47 0 11 34];
b=[-774;-1623];
lb=zeros(7,1);
[x,fval]=intlinprog(f,ic,A,b,[],[],lb,[])