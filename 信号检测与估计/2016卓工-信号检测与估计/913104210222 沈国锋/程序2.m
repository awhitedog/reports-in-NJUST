%计算了脉压增益损失与多普勒频率的曲线，统计了randn，wgn，awgn函数产生噪声的性质
clear all
close all
y=0.5+0.5*square(2*pi/500*(1:1:5000),10);
plot(y)
yy=awgn(y,0);
figure
plot(yy)
fprintf('%f',sum(yy(1600:1800).^2)/200)
pause;

%根据理论表达式绘制脉压增益损失与多普勒频率的曲线
clear all
close all
p=127;%相干长度
t=1/22e6;%码宽
fd=0:1:1000000;%多普勒频率
L=abs(sin(pi.*fd*p*t)/p./sin(pi.*fd*t));
figure
subplot(211);
plot(fd,L);
title('脉压增益损失与多普勒频率的关系'),xlabel('多普勒频率/Hz'),ylabel('损失比');

grid on;
vd=fd./(200/3);
subplot(212);
plot(vd,L);
title('脉压增益损失与目标速度的关系'),xlabel('目标径向速度 m/s'),ylabel('损失比');
grid on;

%验证randm/wgn/awgn函数的功能
close all
clear all
x=ones(1,1000);
y1=randn(1,1000);
y2=wgn(1,1000,0);
y3=awgn(x,5);
y11=xcorr(y1,'coeff');
y11(1:999)=[];
y22=xcorr(y2,'coeff');
y22(1:999)=[];
y33=xcorr(y3-1,'coeff');
y33(1:999)=[];
figure;%作概率直方图，根据经验公式，分29个统计区间
subplot(311);hist(y1,29),title('randn函数');
subplot(312);hist(y2,29),title('wgn函数');
subplot(313);hist(y3-1,29),title('awgn函数');

figure;%作自相关函数和功率谱密度
subplot(331),plot(y1),title('randn函数 时域波形');
subplot(332),plot(linspace(-1000,1000,1999),xcorr(y1,'coeff')),title('自相关函数');
subplot(333),plot(abs(fft(y11))),title('功率谱密度');
% figure;
subplot(334),plot(y2),title('wgn 时域波形');
subplot(335),plot(linspace(-1000,1000,1999),xcorr(y2,'coeff')),title('自相关函数');
subplot(336),plot(abs(fft(y22))),title('功率谱密度');
% figure;
subplot(337),plot(y3),title('awgn 时域波形');
subplot(338),plot(linspace(-1000,1000,1999),xcorr(y3-1,'coeff')),title('自相关函数');
subplot(339),plot(abs(fft(y33))),title('功率谱密度');


