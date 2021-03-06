clc,clear;
width=600;%宽度，像素数
height=300;%高度
left=100;%距屏幕左下角水平距离
bottem=100;%距屏幕左下角垂直距离
set(gcf,'position',[left,bottem,width,height])
a= [0.00 	0.67 	1.33 	2.00 	2.67 	3.33 	4.00 	4.67 	5.33 	6.00 	6.67 	8.00 	9.33 	10.67 	12.00 	13.33 	14.67 	16.00 	17.33 	18.67 	20.00 	23.33 	26.67 	30.00 	33.33 	36.67 	40.00 	43.33 	46.67 	50.00 	53.33 	56.67 	60.00 	63.33 	66.67 
];  %横坐标
b = [62.6708 	62.6682 	62.6606 	62.6629 	62.6642 	62.6605 	62.6522 	62.6573 	62.6574 	62.6524 	62.6475 	62.6502 	62.6426 	62.6428 	62.6373 	62.6350 	62.6314 	62.6269 	62.6257 	62.6186 	62.6195 	62.6095 	62.5960 	62.5938 	62.5839 	62.5701 	62.5680 	62.5582 	62.5441 	62.5421 	62.5324 	62.5180 	62.5161 	62.5066 	62.4914 
]; %纵坐标
c=[49.2186	49.2214	49.2098	49.2155	49.2276	49.2258	49.2094	49.2271	49.2352	49.2286	49.2197	49.2411	49.2339	49.2455	49.2463	49.2483	49.2569	49.2495	49.2664	49.2493	49.2741	49.2694	49.2845	49.2997	49.289	49.3146	49.3239	49.3134	49.3433	49.3467	49.3466	49.3706	49.368	49.3785	49.396
];
d=[13.4522 	13.4468	13.4508	13.4474	13.4366	13.4347	13.4428	13.4302	13.4222	13.4238	13.4278	13.4091	13.4087	13.3973	13.391	13.3867	13.3745	13.3774	13.3593	13.3693	13.3454	13.3401	13.3115	13.2941	13.2949	13.2555	13.2441	13.2448	13.2008	13.1954	13.1858	13.1474	13.1481	13.1281	13.0954
];

% pot([1024,1024],[0,1200],'r');  %画直线
% plot([2048,2048],[0,1200],'r');  %画直线
% plot([3072,3072],[0,1200],'r');  %画直线
% plot([0,4096],[611,611],'g');  %画直线l

plot(a, b, 'x');       %将每个点 用x画出来
hold on;
valuesb = spcrv([[a(1) a a(end)];[b(1) b b(end)]],3);
plot(valuesb(1,:),valuesb(2,:), 'b','LineWidth',1);
plot(a, c, 'o');       %将每个点 用x画出来
hold on;
valuesc = spcrv([[a(1) a a(end)];[c(1) c c(end)]],3);
plot(valuesc(1,:),valuesc(2,:), 'k','LineWidth',1);
plot(a, d, 's');       %将每个点 用x画出来
hold on;
valuesd = spcrv([[a(1) a a(end)];[d(1) d d(end)]],3);
plot(valuesd(1,:),valuesd(2,:), 'r','LineWidth',1);
legend('脉压主瓣峰值','主瓣峰值拟合曲线','脉压第一副瓣峰值','第一副瓣峰值拟合曲线','脉压后主旁比','主旁比拟合曲线');
%ylabel('脉压主旁比/dB');
xlabel('多普勒频移/KHz');
title('多普勒性能损失');
hold on;
set(gca, 'XGrid','on'); 
set(gca, 'YGrid','on'); 
hold on;
syms t
