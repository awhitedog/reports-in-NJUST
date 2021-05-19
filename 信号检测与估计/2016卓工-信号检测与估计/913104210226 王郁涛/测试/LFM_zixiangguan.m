%%---线性调频脉冲雷达仿真
close all;
clear all;

%=========================系统参数=========================
fc = 10e9;                          %载波 10GHz
c = 3e8;                            %光速
l = c/fc;                           %载波波长
T = 200e-6;                         %时宽 200us,脉冲重复周期 200us

B = 26e6;                           %调频带宽 26MHz
Rmin = 0;Rmax = 30e3;               %测距范围
N = 50;                             %相干积累时间不大于10ms
SNR =-10;                           %信噪比
A = 1;                              %目标幅度
R = 1000;                           %目标距离
vt =10;                             %目标速度
fd = 2*vt/l;                        %对应的多普勒频率  

Fs=2*B;Ts=1/Fs;                     %采样频率和采样周期
K=B/T;                              %调频斜率
Rw=Rmax-Rmin;                       %测距范围
Tw=2*Rw/c;                          
Num=T/Ts;                    %每个发射周期采样点数

%=========================LFM=========================


t=linspace(-T/2,T/2,Num);
St=exp(j*pi*K*t.^2);                
subplot(211)
plot(t*1e6,real(St));
xlabel('t/us');
title('线性调频信号');
grid on;axis tight;
subplot(212)
freq=linspace(-Fs/2,Fs/2,Num);
plot(freq*1e-6,fftshift(abs(fft(St))));
xlabel('f/ MHz');
title('线性调频信号的幅频特性');
grid on;axis tight;   



%==================LFM的自相关函数======================
T = 200e-6;                         %时宽 200us,脉冲重复周期 200us

B = 26e6;                           %调频带宽 26MHz
K=B/T;                              %调频斜率
Fs=10*B;
Ts=1/Fs; 
N=T/Ts;
t=linspace(-T/2,T/2,N);
St=exp(j*pi*K*t.^2);               %调频信号表达式
Ht=exp(-j*pi*K*t.^2);              %匹配滤波信号
Sot=conv(St,Ht);
figure(2);
subplot(211);
L=2*N-1;
tt=linspace(-T,T,L);
Z=abs(Sot);
Z=Z/max(Z);                        %归一化
Z=20*log10(Z+1e-6);
Z1=abs(sinc(B.*tt));               %sinc
Z1=20*log10(Z1+1e-6);
tt=tt*B;
plot(tt,Z,tt,Z1,'r.');
axis([-15,15,-50,inf]);
grid on;
legend('仿真结果','sinc');
xlabel('Time in sec\times\itB');ylabel('幅度,dB');
title('匹配滤波后的线性调频输出');
subplot(212)                        %放大仿真结果
N0=3*Fs/B;
t2=-N0*Ts:Ts:N0*Ts;
t2=B*t2;
plot(t2,Z(N-N0:N+N0),t2,Z1(N-N0:N+N0),'r.');
axis([-inf,inf,-50,inf]);grid on;
set(gca,'Ytick',[-13.4,-4,0],'Xtick',[-3,-2,-1,-0.5,0,0.5,1,2,3]);         %第一旁瓣高度，4dB输出脉冲高度
xlabel('归一化时间（t*B）');ylabel('幅度,dB');
title('放大后的自相关');



