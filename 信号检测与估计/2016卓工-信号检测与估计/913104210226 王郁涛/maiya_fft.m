close all;
clear all;

%=========================系统参数=========================
fc = 10e9;                          %载波 10GHz
C = 3e8;                            %光速
l = C/fc;                           %载波波长
T = 200e-6;                         %时宽 200us,脉冲重复周期 200us
B = 26e6;                           %调频带宽 26MHz
M = 50;                             %相干积累时间不大于10ms
snr =-10;                           %信噪比
A = 1;                              %目标幅度
Fs=2*B;Ts=1/Fs;                     %采样频率和采样周期
K=B/T;                              %调频斜率                     
N=round(T/Ts);                      %每个脉冲周期采样点数

Rmin=0;Rmax=20e3;                   %测量距离的min和max
Rw=Rmax-Rmin;
Tw=2*Rw/C;                          
Num=ceil(Tw/Ts);                    %每个发射周期采样点数
v =10;                              %目标速度
fd=2*v/l;                           %多普勒频移

t=linspace(2*Rmin/C,2*Rmax/C,Num);                              
Nfft=2^nextpow2(2*N-1);                         %脉冲压缩时fft点数（频域采样定理，L>M+N-1,不然会混叠）
Raw_data = zeros(M, N);
Maiya = zeros(M, N);

for ii = 1:M     
%---------------构造发射信号和回波信号
t0=linspace(-T/20,T/20,N/10);
t00=linspace(-T/2,T/2,N);
freq=linspace(-Fs/2,Fs/2,N);

z_left0=zeros(1,4680);
z_right0=zeros(1,4680);
yanchi=347;
z_left=zeros(1,4680+yanchi);
z_right=zeros(1,4680-yanchi);


St0=A*exp(j*pi*K*t0.^2);                    
St1=[z_left0,St0,z_right0];                        %发射信号  

sr0=[z_left,St0,z_right];                          %无噪声无多普勒回波信号
st_fd=exp(j*2*pi*K*fd.*t00) ;                      %多普勒频移信号部分
sr10=sr0.*st_fd;                                   %多普勒频移信号
sr11=awgn(sr0,snr,'measured');                     %回波信号加高斯白噪声


   
%---------------脉冲压缩/匹配滤波
    Srw=fft(sr11,Nfft);                             %回波fft
    Sw=fft(St1,Nfft);                                %发射信号fft
    Sot=fftshift(ifft(Srw.*conj(Sw)));              %频域相乘
    N0=Nfft/2-N/2;   
    Z=Sot(N0:N0+N-1);
    Maiya(ii,:) = Z(:);                             %存储当前PRI 期间脉冲压缩的结果
    Z = abs(Z);
    Z=Z/max(Z);
    Z=20*log10(Z+1e-6);                             %对脉压后结果归一化并转换为db值
    figure(5)
    plot(t00*C/2,Z)
    axis([Rmin,Rmax,-60,0]);
    xlabel('距离 / m');ylabel('幅度/dB')
    title('脉冲压缩后的雷达回波');
end

%===========================距离门重排=====================
figure(6)

for i=1:N
PR(i,1:50)=Maiya(i:N:(M-1)*N+i);             %可能性
end
mesh(real(PR));  
title('脉冲压缩后重排结果');

%===========================FFT处理=====================
FFT_Output = fft(Maiya);  
FFT_Outputdb=20*log10(abs(FFT_Output));
fds = 1/T;                                          %重复频率
vt = (0:M-1).*0.5*l*fds/M;                          %遍历目标径向速度v=fd*l*0.5
figure(7)
r = t00*C/2;
mesh(r,vt,FFT_Outputdb);  
view(180,0)
xlabel('距离 /m'); ylabel('目标径向速度 m/s');
title('FFT处理结果');
figure(8)
contour(r,vt,FFT_Outputdb);  
xlabel('距离 /m'); ylabel('目标径向速度 m/s');
title('FFT处理结果投影图');

