clc;
statistical= xlsread('Í³¼Æ-Åâ¸¶ÂÊ.xlsx');
statistical(isnan(statistical)) = 0;
STATISTIC_COUNTER=zeros(8,4);
STATISTIC_COUNTER(:,1)=[0 1 2 3 4 5 6 7];
for k=1:size(STATISTIC_COUNTER,1)
for i=1:size(statistical,1)
    if STATISTIC_COUNTER(k,1)==statistical(i,15)
        STATISTIC_COUNTER(k,2)=1+STATISTIC_COUNTER(k,2);
        if statistical(i,21)==1
            STATISTIC_COUNTER(k,3)=STATISTIC_COUNTER(k,3)+1;
        end
    end
end
STATISTIC_COUNTER(k,4)=STATISTIC_COUNTER(k,3)/STATISTIC_COUNTER(k,2);
end
[p1,S1,mu1] = polyfit(STATISTIC_COUNTER(:,1),STATISTIC_COUNTER(:,4),5)
x=STATISTIC_COUNTER(:,1);
y=STATISTIC_COUNTER(:,4);
z=(-1.16e+09)+(-3.301e+11)*sin(-0.001504*x)+ (2.089e+09)*cos(2*-0.001504*x)+(2.641e+11)*sin(2*-0.001504*x)+(-9.284e+08)*cos(3*-0.001504*x)+ (-6.602e+10)*sin(3*-0.001504*x);
plot(x,y,'X','color',[1 0 0])
hold on;
plot(x,z,'+','color',[0 0 1])