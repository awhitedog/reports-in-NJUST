%%---线性调频脉冲雷达仿真
close all;
clear all;

%=========================系统参数=========================
fc = 10e9;                          %载波 10GHz
C = 3e8;                            %光速
l = C/fc;                           %载波波长
T = 200e-6;                         %时宽 200us,脉冲重复周期 200us

B = 26e6;                           %调频带宽 26MHz
Rmin = 0;Rmax = 30e3;               %测距范围
M = 50;                             %相干积累时间不大于10ms
SNR =-10;                           %信噪比
A = 1;                              %目标幅度
Fs=2*B;Ts=1/Fs;                     %采样频率和采样周期
K=B/T;                              %调频斜率
Rw=Rmax-Rmin;                       %测距范围
Tw=2*Rw/C;                          
N=round(T/Ts);                      %每个发射周期采样点数

%===========================回波信号=====================
t0=linspace(-T/20,T/20,N/10);
yanchi=347;
z_left=zeros(1,4680+yanchi);
z_right=zeros(1,4680-yanchi);
St0=A*exp(j*pi*K*t0.^2);                %调频信号表达式
Ht=A*exp(-j*pi*K*t0.^2);
sr0=[z_left,St0,z_right];             %无噪声无多普勒回波信号
snr=-10;                              %信噪比
sr1=awgn(sr0,snr);
freq=linspace(-Fs/2,Fs/2,N);
figure(3)
subplot(211)
plot(freq*1e-6,fftshift(abs(fft(sr0))));
xlabel('f/ MHz');
axis tight;
title('无噪声回波的幅频特性');
subplot(212)
plot(freq*1e-6,fftshift(abs(fft(sr1))));
xlabel('f/ MHz');
axis tight;
title('有噪声回波的幅频特性');

v =10;                              %目标速度
fd=2*v/l;                           %多普勒频移

tt=linspace(-T/2,T/2,N);
st_fd=exp(j*2*pi*K*fd.*tt)          %多普勒频移信号部分
sr10=sr0.*st_fd;                    %多普勒频移信号
sr11=awgn(sr0,snr,'measured');      %加高斯白噪声
figure(4)
subplot(211)
plot(freq*1e-6,fftshift(abs(fft(sr10))));
xlabel('f/ MHz');
axis tight;
title('无噪声多普勒回波的幅频特性');
subplot(212)
plot(freq*1e-6,fftshift(abs(fft(sr11))));
xlabel('f/ MHz');
axis tight;
title('有噪声多普勒回波的幅频特性');


