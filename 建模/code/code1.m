num = xlsread('C:\Users\LENOVO\Desktop\2019_MCM-ICM_Problems\2018_MCMProblemC_DATA\synthetic and Heroin .xlsx',2);
m=zeros(8,1);
[c,b]=size(num);
B = zeros(8,15);
n=1; 
d=39155
for x=0:1:11
    n=1
for j=2010:2017
    for i=1:c
    if num(i,1)==j&num(i,6)==(d+2*x)
        B(n,2+x)=B(n,2+x)+num(i,8); %a=num(i,9);
    end
   % B(n,3)=a;
    B(n,1)=j;
    end
    n=n+1;
end
end
    
       
        