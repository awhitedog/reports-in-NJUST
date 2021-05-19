clc;
statistical= xlsread('统计 - 副本.xlsx');
statistical(isnan(statistical)) = 0;
NUM_COUNTER=zeros(10,3);
x=[1 3 5 7 9 11 13 15 16 17];
y=[1 2 3 4 5 6 7 8];
count=0;
for i=1:65535
    for j=1:8
    if statistical(i,x(2))==0&&statistical(i,x(3))==1&&statistical(i,x(4))==0&&statistical(i,x(5))==2&&statistical(i,x(6))==1&&statistical(i,x(7))==2&&statistical(i,x(8))==3&&statistical(i,x(9))==0
   count=count+1;
        if statistical(i,x(1))==y(j)
       NUM_COUNTER(j,1)=NUM_COUNTER(j,1)+1;
       if statistical(i,x(10))==1
           NUM_COUNTER(j,2)=NUM_COUNTER(j,2)+1;
       end
   end
    end
    NUM_COUNTER(j,3)=NUM_COUNTER(j,2)/NUM_COUNTER(j,1);
    end
end