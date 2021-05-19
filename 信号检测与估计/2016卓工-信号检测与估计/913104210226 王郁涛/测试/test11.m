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
C=3e8;                              %光速
Fs=4*B;Ts=1/Fs;                     %采样频率和采样周期
K=B/T;                              %调频斜率
Rw=Rmax-Rmin;                       %测距范围
Tw=2*Rw/C;                          
Num=ceil(Tw/Ts);                    %每个发射周期采样点数

%===========================自相关函数输出=====================
t0=linspace(-T/20,T/20,Num/10);

St=exp(j*pi*K*t0.^2);               %调频信号表达式
Ht=exp(-j*pi*K*t0.^2);

Z=zeros(1,round(0.45*Num));         %补零函数
St=[Z,St,Z];                        %横向前后补零
Ht=[Z,Ht,Z];

Sot0=conv(St,Ht);                   %自相关函数
figure(1)
subplot(211)
L=2*Num-1;
t1=linspace(-T,T,L);
Z0=abs(Sot0);
Z0=Z0/max(Z0);                      %归一化
Z0=20*log10(Z0+1e-6);
t1=t1*B;                            %归一化时间，时宽带宽积
plot(t1,Z0);
%axis([-15,15,-50,inf]);
grid on;
legend('仿真结果');xlabel('归一化时间（t*B）');ylabel('幅度,dB');
title('自相关函数输出');
subplot(212)                        %放大仿真结果
N1=5*Fs/B;
t2=-N1*Ts:Ts:N1*Ts;
t2=B*t2;
plot(t2,Z0(Num-N1:Num+N1));
axis([-inf,inf,-50,inf]);grid on;
set(gca,'Ytick',[-4,-1,0],'Xtick',[-6,-3,-1,-0.5,0,0.5,1,3,6]);xlabel('归一化时间（t*B）');ylabel('幅度,dB');
title('放大后的自相关');

%===========================生成回波信号=====================     
t=linspace(2*Rmin/C,2*Rmax/C,Num);                              
Nfft=2^nextpow2(Num+Num-1);                         %脉冲压缩时fft点数
Raw_data = zeros(N, Num);
Maiya = zeros(N, Num);
%---------构造目标回波
    td=t-2*R/C;
    t_yc=zeros(1,round(2*R/C/Ts));
    fdc=fd'*ones(1,Num);
    Srt=A*(exp(j*pi*K*td.^2 + j*2*pi*fdc*T));    %目标回波视频表达式
    Srt=[t_yc,Srt];
    Srt = awgn(Srt,SNR,'measured');                 %加入高斯白噪声
   
    figure(2)
    subplot(211)
    plot(t*1e6,real(Srt));
    axis tight;
    xlabel('时间 /us');ylabel('幅度')
    title('脉冲压缩前的雷达回波');