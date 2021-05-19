close all;
clear all;
clc;
y=0;
T=2e-4;                          %时宽
B=30e6;                           %带宽
K=B/T;                           %调频斜率
Fs=8*B;Ts=1/Fs;  
N=T/Ts+1;                        %采样点数
t=0:Ts:T
NUM=1;                          %相干积累周期数
St=exp(j*pi*K*t.^2);             %发射信号
%%__________________自相关函数___________________
[a,b]=xcorr(St);
Z=abs(a);
figure(1)
plot(Z);
Z=Z/max(Z);                      %归一化
Z=20*log10(Z);                   %化成分贝
figure(2)        
%%__________放大_______
 N0=6*Fs/B;
t2=-N0*Ts:Ts:N0*Ts;
t2=B*t2;
plot(t2,Z(N-N0:N+N0) );
axis([-inf,inf,-30,inf]);grid on;
set(gca,'Ytick',[-13.4,-4,0],'Xtick',[-3,-2,-1,-0.5,0,0.5,1,2,3]);
xlabel('时间*B');
ylabel('幅值,dB');
title('放大后的自相关');
%%_____________________结束__________________________
C=3e8;               %光速
R=0 ;     %距离
V=0  ;        %速度          
f0=10e9;             %载频 
lambda=C/f0;         %波长
t0=floor(2*R*Fs/C)+1     %延时的点数
Sr=repmat(St,1,NUM);        %相干积累
sr=[Sr(NUM*N-t0+1:NUM*N) Sr(1:NUM*N-t0)]     %延时   
fd=2*V/lambda ;                 %多普勒频率
t=0:Ts:(N*NUM-1)*Ts;
Sd=exp(2*j*pi*fd*t);            %产生多普勒信号
SR=sr.*Sd;                      %回波信号
h=fliplr(St) ;            %构造匹配滤波器
pipei=conv(conj(h),SR);    %对回波进行匹配滤波
figure(3)
pipei_db=10*log10(abs(pipei.^2));
plot(pipei_db);
title('脉压/db');
axis([4780,4850,50,75]);grid on;
set(gca,'Ytick',[69.62,73.62],'Xtick',[4798,4806]);%%脉压，距离为0，速度为0,8倍采样频率，num=1
