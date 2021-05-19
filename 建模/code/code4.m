num = xlsread('C:\Users\LENOVO\Desktop\2019_MCM-ICM_Problems\2018_MCMProblemC_DATA\部分数据.xlsx',8);

B = zeros(5,23);
[c,b]=size(num);
e=[21 39 42 51 54];
for k=1:1:5
   d=e(1,k); 
for i=1:1:c
    for j=3:1:b
    if num(i,1)==d
        B(k,j-1)=num(i,j)+B(k,j-1);
    end
    end
end
    B(k,1)=d;
end