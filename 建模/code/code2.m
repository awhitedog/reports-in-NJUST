num = xlsread('C:\Users\LENOVO\Desktop\2019_MCM-ICM_Problems\2018_MCMProblemC_DATA\MCM_NFLIS_Data.xlsx',2);
m=zeros(8,1);
[c,b]=size(num);
B = zeros(8,15);
n=1; 
d=39155
for x=0:1:10
    n=1
for j=2010:2017
    for i=1:c
    if num(i,1)==j&num(i,6)==(d+2*x)
         a=num(i,9);
    end
    B(n,3+x)=a;
    B(n,1)=j;
    end
    n=n+1;
end
end
    
       
        