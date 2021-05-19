%==================================================================
%参数设定
close all
clear all
T=200e-6;                          %时宽
B=23e6;                           %线性调频带宽
K=B/T;    
fc=10e9;                         %雷达载频
Fs=5*B;Ts=1/Fs;                   %采样频率和采样周期
N=T/Ts;                           %每个发射周期采样点数
n=30;
v=10;                             %speed
c=3e8;
R=1000;                           %距离
Rm=T*c/2;                         %雷达最大测量距离
fd=666.7                          %多普勒频移
cita=1;                           %单目标情况
Nfft=2^nextpow2(N+N-1);           %FFT点数计算
t=linspace(0,T,N);
St=exp(j*pi*K*t.^2);                 %产生一个周期的线性调频波信号

SNR=input('please input SNR:');

%=======================双目标==================================
cita = [1,1];   %% 各个目标的归一化幅度
 v = [16,20];  %目标径向速度 m/s
 fd = 2*v/c*fc;  %对应的多普勒频率
 R=[8000,8000]; %各个目标距离

%==================================================================
Adata = zeros(n, N);           % 两个矩阵用来存储30个周期内        
Bdata = zeros(n, N); % 的回拨信号和脉压后的信号
Cdata=zeros(1,n);    %用来储存主瓣峰值
M=length(R);
A=sqrt(cita);         
%==================================================================

for i = 1:n 
      
%---------构造目标回波
td=ones(M,1)*t-2*R'/c*ones(1,N);
fdc=fd'*ones(1,N);
Stecho=A*(exp(j*pi*K*td.^2 + j*2*pi*fdc*i*T));%目标回波视频表达式
Stecho = awgn(Stecho,SNR,'measured');        %加入高斯白噪声
Adata(i,:) = Stecho(:);                      %存储当前帧回波

     Swecho=fft(Stecho,Nfft);                           %回波fft
     t0=linspace(-T/2,T/2,N);
     St=exp(j*pi*K*t0.^2);                       
     Sw=fft(St,Nfft);                             
     Stmy=fftshift(ifft(Swecho.*conj(Sw)));              %频域相乘
 %=========================================================
    N0=(Nfft-N)/2;

    ZZ=Stmy(N0:N0+N-1);
    Bdata(i,:) = ZZ(:);   %%存储当前PRI 期间脉冲压缩的结果
    
    Cdata(1,i)=max(abs(ZZ));
    zz=abs(ZZ);
    zz=zz/max(zz);
    zz=20*log10(zz);
    zmax(1,i)=max(zz);
    zmean(1,i)=mean(zz);
    
   
  st=exp(j*pi*K*t0.^2);%调频信号表达式  
  Ht=exp(-j*pi*K*t0.^2);%匹配滤波器
  Stme=conv(st,Ht);%信号经过匹配滤波器
  figure(3)
  subplot(211)
  L=2*N-1;
  t1=linspace(-T,T,L);
  Z=abs(Stme);
  Z=Z/max(Z);%归一化
  Z=20*log10(Z+1e-6);
  Z1=abs(sinc(B.*t1));%辛克函数
  Z1=20*log10(Z1+1e-6);
  t1=t1*B;
  plot(t1,Z,t1,Z1,'k.');
  axis([-15,15,-50,inf]);grid on;
  legend('仿真结果','辛克函数');xlabel('归一化时间（t*B）');ylabel('幅度,dB');
  title('匹配滤波后的信号');
  subplot(212)%放大仿真结果
   N0=3*Fs/B;
  t2=-N0*Ts:Ts:N0*Ts;
  t2=B*t2;
  plot(t2,Z(N-N0:N+N0),t2,Z1(N-N0:N+N0),'r.');
  axis([-inf,inf,-50,inf]);grid on;
  set(gca,'Ytick',[-13.4,-4,0],'Xtick',[-3,-2,-1,-0.5,0,0.5,1,2,3]);xlabel('归一化时间（t*B）');ylabel('幅度,dB');
  title('放大后的匹配滤波信号');
end
 figure(1)
    subplot(211)
    plot(t*1e6,real(Stecho));
    axis tight;
    xlabel('时间 /us');ylabel('幅度')
    title('脉冲压缩前的雷达回波');
    subplot(212)
    plot(t*c/2,zz)
    axis([0,Rm,-60,0]);%这里有问题
    xlabel('距离 / m');ylabel('幅度/dB')
    title('脉冲压缩后的雷达回波');
figure(2)
rbin = t*c/2;
pribin = 1:n;
mesh(rbin,pribin,abs(Bdata));  %%
xlabel('距离 /m'); ylabel('脉冲重复周期');
title('脉冲压缩后数据重排结果');
%%--------- FFT 处理-----------
FFT_Output = fft(Bdata);  
FFT_Outputdb=20*log10(abs(FFT_Output));
fds = 1/T;      
doppler_bin = (0:n -1).*0.5*c/fc*fds/n;  %
rbin = t*c/2;
figure(4)
mesh(rbin,doppler_bin,FFT_Outputdb);  
xlabel('距离 /m'); ylabel('目标径向速度 m/s');
title('FFT处理结果');
figure(5)
contour(rbin,doppler_bin,FFT_Outputdb);  
xlabel('距离 /m'); ylabel('目标径向速度 m/s');
title('FFT处理结果图');

Zmax=mean(zmax);
Zmean=mean(zmean);
disp(Zmax-Zmean);

%figure(6)
%plot(500*(1:n),Cdata);
%axis tight;
%figure(6)
%xlabel('Time in u sec');
%title('Real part of chirp signal');
%freq=linspace(0,Fs,N);
%plot(freq*1e-6,fftshift(abs(fft(St))));
%xlabel('Frequency in MHz');
%title('Magnitude spectrum of chirp signal');
%grid on;axis tight;