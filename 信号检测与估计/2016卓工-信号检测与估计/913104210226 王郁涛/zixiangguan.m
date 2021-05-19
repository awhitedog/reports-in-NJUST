%%---线性调频脉冲雷达仿真
close all;
clear all;

%=========================系统参数=========================
fc = 10e9;                          %载波 10GHz
C = 3e8;                            %光速
l = C/fc;                           %载波波长
T = 200e-6;                         %时宽 200us,脉冲重复周期 200us

B = 26e6;                           %调频带宽 26MHz
M = 50;                             %相干积累时间不大于10ms
SNR =-10;                           %信噪比
A = 1;                              %目标幅度
Fs=2*B;Ts=1/Fs;                     %采样频率和采样周期
K=B/T;                              %调频斜率
                        
N=round(T/Ts);                      %每个发射周期采样点数


%============================LFM=============================
t0=linspace(-T/20,T/20,N/10);
t00=linspace(-T/2,T/2,N);
freq=linspace(-Fs/2,Fs/2,N);

z_left0=zeros(1,4680);
z_right0=zeros(1,4680);
St0=A*exp(j*pi*K*t0.^2);                    %调频信号表达式
St1=[z_left0,St0,z_right0];                 %调频信号表达式补零  
figure(1)
subplot(211)
plot(t00*1e6,real(St1));                    %LFM时域
xlabel('t/us');
title('线性调频信号');
grid on;axis tight;
subplot(212)
freq=linspace(-Fs/2,Fs/2,N);
plot(freq*1e-6,fftshift(abs(fft(St1))));    %LFM幅频特性 
xlabel('f/ MHz');
title('线性调频信号的幅频特性');
grid on;axis tight;   






%===========================自相关函数输出=====================
t0=linspace(-T/20,T/20,N/10);
z_left0=zeros(1,4680);
z_right0=zeros(1,4680);
St0=A*exp(j*pi*K*t0.^2);                %调频信号表达式
Ht0=A*exp(-j*pi*K*t0.^2);

St1=[z_left0,St0,z_right0];            %调频信号表达式补零  
Ht1=[z_left0,Ht0,z_right0];

Sot0=conv(St1,Ht1);                   %自相关函数
figure(2)
subplot(211)
L=2*N-1;
t1=linspace(-T,T,L);
Z0=abs(Sot0);
Z0=Z0/max(Z0);                      %归一化
Z0=20*log10(Z0+1e-6);
t1=t1*B;
plot(t1,Z0);
axis([-30,30,-50,inf]);grid on;
legend('仿真结果');xlabel('归一化时间（t*B）');ylabel('幅度,dB');
title('自相关函数输出');
subplot(212)                        %放大仿真结果
N1=10*Fs/B;
t2=-N1*Ts:Ts:N1*Ts;
t2=B*t2;
plot(t2,Z0(N-N1:N+N1));
axis([-inf,inf,-50,inf]);grid on;
set(gca,'Ytick',[-13.4,-4,0],'Xtick',[-5,-3,-1,-0.5,0,0.5,1,3,5]);xlabel('归一化时间（t*B）');ylabel('幅度,dB');
title('放大后的自相关');
