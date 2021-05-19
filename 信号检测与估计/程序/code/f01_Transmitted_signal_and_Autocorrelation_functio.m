clc;
clear;
B=34e6;                 %带宽
T=200e-6;                 %周期
D=10e-2;            %占空比
Fc=10e9;            %载频
SNRi=-25;              %输入信噪比
V=0;              %目标速度
A=3;               %目标幅度
R=0;            %目标距离
tt=10e-3;           %相干积累时间
%******************常数或中间参数*******************
Tau=D*T;                %脉宽
K=B/Tau;              %线性调频斜率
Fs=2*B;             %采样频率
Ts=1/Fs;            %采样周期
C=3e8;              %光速C
M=tt/T;             %脉冲重复个数
%******************线性调频信号***************
N=round(T/Ts);
t1=linspace(-Tau/2,Tau/2,N*D);
t=linspace(-T/2,T/2,N);
St_0=exp(2*j*pi*(+0.5*K*t1.^2));
N1=round(N*(1-D)/2);
zero=zeros(1,N1);%补零
St=[zero,St_0,zero];
%LFM时域波形
 figure(1);
 subplot(2,1,1)
 plot(t*1e6,real(St));
 xlabel('时间 单位：us');
 title('线性调频信号时域波形');
 grid on;axis tight;
%LFM频域波形
 f=linspace(-Fs/2,Fs/2,N);
 figure(1);
 subplot(2,1,2)
 fftshift(abs(fft(St)));
 St_FFT=fftshift(abs(fft(St)));
 plot(f*1e-6,St_FFT);
 xlabel('频率 单位：MHz');
 title('线性调频信号幅频特性');
 grid on;axis tight;
%***************自相关函数*********************
Ht_0=fliplr(St);
Ht=conj(Ht_0);
Sot=conv(St,Ht);
N2=2*N-1;
t2=linspace(-T,T,N2);
Z0=abs(Sot);
%自相关函数
 figure(2)
 subplot(2,1,1)
 plot(t2*1e6,Z0);
 axis([-21,21,-inf,inf]);grid on;
 xlabel('时间 单位：us');
 title('自相关函数');
%自相关函数dB
 figure(2)
 subplot(2,1,2)
Z1=20*log10(Z0);
 plot(t2*1e6,Z1);
 axis([-21,21,-inf,inf]);grid on;
 xlabel('时间 单位：us');
 title('自相关函数（dB）');
%自相关函数放大
 figure(3)
 subplot(2,1,1)
 plot(t2*1e6,Z1);
 axis([-1,1,-5,70]);grid on;
 xlabel('时间 单位：us');
 title('自相关函数（dB）');
%自相关函数放大2
 figure(3)
 subplot(2,1,2)
Z0=Z0/max(Z0);
Z2=20*log10(Z0);
 plot(t2*1e6,Z2);
 axis([-1,1,-5,1]);grid on;
 xlabel('时间 单位：us');
 title('自相关函数（归一化）');
%查找自相关函数参数
 t_find=linspace(-0.6e-6,0.6e-6,N*100);%插值范围
 Z_1=interp1(t2,Z1,t_find,'linear'); %内插值
 Z_2=interp1(t2,Z2,t_find,'linear'); %内插值
 range=double(-0.2*1e-6);[para1,para2] = find(t_find<=range);
 m_1_1=max(para2);
 range=double(0.2*1e-6);[para1,para2] = find(t_find<=range);
 m_1_2=max(para2);
 max_Main_Lobe=max(Z_1(:));%主瓣高度
 range=double(0.3*1e-6);[para1,para2] = find(t_find<=range);
 m_1_1=max(para2);
 range=double(0.6*1e-6);[para1,para2] = find(t_find<=range);
 m_1_2=max(para2);
 max_Side_Lobe=max(Z_1(m_1_1:m_1_2));%第一旁瓣
 Main_lobe_side_lobe_ratio=max_Main_Lobe-max_Side_Lobe;%主瓣旁瓣比
 range=double(-4);[para1,para2] = find(Z_2>=range);
 m_1_1=max(para2);
 m_1_2=min(para2);
 max_4dB_Output_Pulse_Width=(t_find(m_1_1)-t_find(m_1_2))*1e9;%4dB输出带宽

%  range=double(-0.2*1e-6);[para1,para2] = find(t2<=range);
%  m_1_1=max(para2);
%  range=double(0.2*1e-6);[para1,para2] = find(t2<=range);
%  m_1_2=max(para2);
%  max_Main_Lobe=max(Z1(:));%主瓣高度
%  range=double(0.3*1e-6);[para1,para2] = find(t2<=range);
%  m_1_1=max(para2);
%  range=double(0.6*1e-6);[para1,para2] = find(t2<=range);
%  m_1_2=max(para2);
%  max_Side_Lobe=max(Z1(m_1_1:m_1_2));%第一旁瓣
%  Main_lobe_side_lobe_ratio=max_Main_Lobe-max_Side_Lobe;%主瓣旁瓣比
%  range=double(-4);[para1,para2] = find(Z2>=range);
%  m_1_1=max(para2);
%  m_1_2=min(para2);
%  max_4dB_Output_Pulse_Width=(t2(m_1_1)-t2(m_1_2))*1e9;%4dB输出带宽

