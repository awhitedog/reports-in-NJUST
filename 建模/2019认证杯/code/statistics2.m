clc;
statistical= xlsread('统计-赔付率.xlsx');
statistical(isnan(statistical)) = 0;
NUM_COUNTER=zeros(size(statistical,1),1);
STATISTIC_COUNTER=zeros(610,13);
parameter=[3 5 7 9 11 13 15 16 19 21];
k=1;
for i=1:size(statistical,1)
    if NUM_COUNTER(i)==0 %确认当前行是否被统计
        NUM_COUNTER(i)=1;
STATISTIC_COUNTER(k,1)=statistical(i,parameter(1));
STATISTIC_COUNTER(k,2)=statistical(i,parameter(2));
STATISTIC_COUNTER(k,3)=statistical(i,parameter(3));
STATISTIC_COUNTER(k,4)=statistical(i,parameter(4));
STATISTIC_COUNTER(k,5)=statistical(i,parameter(5));
STATISTIC_COUNTER(k,6)=statistical(i,parameter(6));
STATISTIC_COUNTER(k,7)=statistical(i,parameter(7));
STATISTIC_COUNTER(k,8)=statistical(i,parameter(8));
STATISTIC_COUNTER(k,9)=statistical(i,parameter(9));
for j=1:size(statistical,1) %统计数量
    if STATISTIC_COUNTER(k,1)==statistical(j,parameter(1))&&STATISTIC_COUNTER(k,2)==statistical(j,parameter(2))&&STATISTIC_COUNTER(k,3)==statistical(j,parameter(3))&&STATISTIC_COUNTER(k,4)==statistical(j,parameter(4))&&STATISTIC_COUNTER(k,5)==statistical(j,parameter(5))&&STATISTIC_COUNTER(k,6)==statistical(j,parameter(6))&&STATISTIC_COUNTER(k,7)==statistical(j,parameter(7))&&STATISTIC_COUNTER(k,8)==statistical(j,parameter(8))&&STATISTIC_COUNTER(k,9)==statistical(j,parameter(9))
    STATISTIC_COUNTER(k,11)=STATISTIC_COUNTER(k,11)+1;
    NUM_COUNTER(j)=1;
    if statistical(j,parameter(10))==1
        STATISTIC_COUNTER(k,12)=STATISTIC_COUNTER(k,12)+1;
    end
    end
end
STATISTIC_COUNTER(k,13)=STATISTIC_COUNTER(k,12)/STATISTIC_COUNTER(k,11);
    k=k+1;
    end
end

x=zeros(size(STATISTIC_COUNTER,1),size(parameter,1));
for i=1:size(parameter,2)-1
x(:,i)=STATISTIC_COUNTER(:,i);
end
y=STATISTIC_COUNTER(:,13);
