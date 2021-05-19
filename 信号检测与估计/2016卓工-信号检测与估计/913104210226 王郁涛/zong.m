% Detection and Estimation
% wangyutao  913104210226


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
Fs=6*B;Ts=1/Fs;                     %采样频率和采样周期
K=B/T;                              %调频斜率
Rw=Rmax-Rmin;                       %测距范围
Tw=2*Rw/C;                          
Num=ceil(Tw/Ts);                    %每个发射周期采样点数

%===========================自相关函数输出=====================
t0=linspace(-T/2,T/2,Num);

St=exp(j*pi*K*t0.^2);               %调频信号表达式
Ht=exp(-j*pi*K*t0.^2);

Sot0=conv(St,Ht);                   %自相关函数
figure(1)
subplot(211)
L=2*Num-1;
t1=linspace(-T,T,L);
Z0=abs(Sot0);
Z0=Z0/max(Z0);                      %归一化
Z0=20*log10(Z0+1e-6);
t1=t1*B;
plot(t1,Z0);
axis([-15,15,-50,inf]);grid on;
legend('仿真结果');xlabel('归一化时间（t*B）');ylabel('幅度,dB');
title('自相关函数输出');
subplot(212)                        %放大仿真结果
N1=5*Fs/B;
t2=-N1*Ts:Ts:N1*Ts;
t2=B*t2;
plot(t2,Z0(Num-N1:Num+N1));
axis([-inf,inf,-50,inf]);grid on;
set(gca,'Ytick',[-13.4,-4,0],'Xtick',[-3,-2,-1,-0.5,0,0.5,1,2,3]);xlabel('归一化时间（t*B）');ylabel('幅度,dB');
title('放大后的自相关');

%===========================生成回波信号=====================     
t=linspace(2*Rmin/C,2*Rmax/C,Num);                              
Nfft=2^nextpow2(Num+Num-1);                         %脉冲压缩时fft点数
Raw_data = zeros(N, Num);
Maiya_output = zeros(N, Num);
for ii = 1:N     
%---------构造目标回波
    td=t-2*R/C;
    fdc=fd'*ones(1,Num);
    Srt=A*(exp(j*pi*K*td.^2 + j*2*pi*fdc*ii*T));    %目标回波视频表达式
    Srt = awgn(Srt,SNR,'measured');                 %加入高斯白噪声
    Raw_data(ii,:) = Srt(:);                        %存储当周期回波
    figure(2)
    subplot(211)
    plot(t*1e6,real(Srt));
    axis tight;
    xlabel('时间 /us');ylabel('幅度')
    title('脉冲压缩前的雷达回波');
%---------------脉冲压缩/匹配滤波
    Srw=fft(Srt,Nfft);                              %回波fft
    t0=linspace(-Tw/2,Tw/2,Num);
    St=exp(j*pi*K*t0.^2);                       
    Sw=fft(St,Nfft);                             
    Sot=fftshift(ifft(Srw.*conj(Sw)));              %频域相乘
    N0=Nfft/2-Num/2;   
    Z=Sot(N0:N0+Num-1);
    Maiya_output(ii,:) = Z(:);                      %存储当前PRI 期间脉冲压缩的结果
    Z = abs(Z);
    Z=Z/max(Z);
    Z=20*log10(Z+1e-6);                             %对脉压后结果归一化并转换为db值
    subplot(212)
    plot(t*C/2,Z)
    axis([Rmin,Rmax,-60,0]);
    xlabel('距离 / m');ylabel('幅度/dB')
    title('脉冲压缩后的雷达回波');
end

%===========================距离门重排=====================
figure(3)
for i=1:Num
PR(i,1:50)=Maiya_output (i:Num:(N-1)*Num+i);
end
mesh(real(PR));  
title('脉冲压缩后重排结果');

%===========================FFT处理=====================
FFT_Output = fft(Maiya_output);  
FFT_Outputdb=20*log10(abs(FFT_Output));
fds = 1/T;                                          %重复频率
doppler_bin = (0:N-1).*0.5*l*fds/N;                 
r = t*C/2;
figure(4)
mesh(r,doppler_bin,FFT_Outputdb);  
view(180,0)
xlabel('距离 /m'); ylabel('目标径向速度 m/s');

title('FFT处理结果');
figure(5)
contour(r,doppler_bin,FFT_Outputdb);  
xlabel('距离 /m'); ylabel('目标径向速度 m/s');
title('FFT处理结果投影图');
