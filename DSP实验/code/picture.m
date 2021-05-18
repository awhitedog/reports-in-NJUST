clc,clear;
a = 1:1:6; %横坐标
b = [8.0 9.0 10.0 15.0 35.0 40.0]; %纵坐标
plot(a, b, 'b'); %自然状态的画图效果
hold on;
%第一种，画平滑曲线的方法
c = polyfit(a, b, 2);  %进行拟合，c为2次拟合后的系数
d = polyval(c, a, 1);  %拟合后，每一个横坐标对应的值即为d
plot(a, d, 'r');  %拟合后的曲线

plot(a, b, '*');  %将每个点 用*画出来
hold on;
%第二种，画平滑曲线的方法
values = spcrv([[a(1) a a(end)];[b(1) b b(end)]],3);
plot(values(1,:),values(2,:), 'g');

legend('1','2','3');
grid on;