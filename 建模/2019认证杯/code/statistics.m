clc;
statistical= xlsread('统计-续保率.xlsx');
statistical(isnan(statistical)) = 0;
NUM_COUNTER=zeros(size(statistical,1),1);
STATISTIC_COUNTER=zeros(610,13);
parameter=[1 3 5 7 9 11 13 15 16 19 20];
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
STATISTIC_COUNTER(k,10)=statistical(i,parameter(10));
for j=1:size(statistical,1) %统计数量
    if STATISTIC_COUNTER(k,1)==statistical(j,parameter(1))&&STATISTIC_COUNTER(k,2)==statistical(j,parameter(2))&&STATISTIC_COUNTER(k,3)==statistical(j,parameter(3))&&STATISTIC_COUNTER(k,4)==statistical(j,parameter(4))&&STATISTIC_COUNTER(k,5)==statistical(j,parameter(5))&&STATISTIC_COUNTER(k,6)==statistical(j,parameter(6))&&STATISTIC_COUNTER(k,7)==statistical(j,parameter(7))&&STATISTIC_COUNTER(k,8)==statistical(j,parameter(8))&&STATISTIC_COUNTER(k,9)==statistical(j,parameter(9))&&STATISTIC_COUNTER(k,10)==statistical(j,parameter(10))
    STATISTIC_COUNTER(k,11)=STATISTIC_COUNTER(k,11)+1;
    NUM_COUNTER(j)=1;
    if statistical(j,parameter(11))==1
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
stepwise()
 beta=[0.54828   0.80737  0.0336817  0.0405936  0 0.0677043  0   0.00482708  0.0135171   0]
 beta_0=0.0663591;
 z=zeros(size(y,1),1)
 for i=1:size(x,1)
     for j=1:10
     z(i)=z(i)+beta(j)*x(i,j);
     end
     z(i)=z(i)+beta_0;
 end
 delta=zeros(size(y,1),1)
for i=1:size(y,1)
  delta(i)=y(i)-z(i);
end
histfit(delta);
normplot(delta);
[y2 x2]=hist(delta,15);
bar(x2,y2);
hold on;
[muhat,sigmahat,muci,sigmaci]=normfit(delta);
x1 = -1.5:0.0001:1.5;
y1= normpdf(x1, -0.1609, 0.2635)*800;
plot(x1,y1,'r','LineWidth',3);
