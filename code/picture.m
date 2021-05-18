clc,clear;
width=600;%宽度，像素数
height=300;%高度
left=100;%距屏幕左下角水平距离
bottem=100;%距屏幕左下角垂直距离
set(gcf,'position',[left,bottem,width,height])
a = [600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200 2300 2400 2500 2600 2700
];  %横坐标
b = [120 200 280 360 440 560 680 720 800 840 800 800 680 560 480 280 280 200 200 120 120 120
]; %纵坐标

% pot([1024,1024],[0,1200],'r');  %画直线
% plot([2048,2048],[0,1200],'r');  %画直线
% plot([3072,3072],[0,1200],'r');  %画直线
% plot([0,4096],[611,611],'g');  %画直线l

plot(a, b, 'x');       %将每个点 用x画出来
hold on;
values = spcrv([[a(1) a a(end)];[b(1) b b(end)]],3);
plot(values(1,:),values(2,:), 'r','LineWidth',1);
ylabel('幅度/mv');
xlabel('频率/Hz');
%title('');
hold on;
set(gca, 'XGrid','on'); 
set(gca, 'YGrid','on'); 
hold on;
syms t
