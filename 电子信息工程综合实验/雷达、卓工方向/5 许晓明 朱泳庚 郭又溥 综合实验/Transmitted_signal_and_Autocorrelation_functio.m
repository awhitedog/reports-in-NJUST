clc;
clear;
B=10e6;             %带宽
T=5e-5;             %脉冲重复周期
Tau=2e-6;           %脉宽
Fc=16e9;            %载频
F0=7.5e6;
SNRi=30;            %输入信噪比
V=0;              %目标速度
A=0.01;           %目标幅度
R=0;            %目标距离
%******************常数或中间参数*******************
D=Tau/T;            %占空比
K=B/Tau;              %线性调频斜率
Fs=100e6;             %采样频率
Ts=1/Fs;            %采样周期
C=3e8;              %光速C
%******************线性调频信号***************
N=round(T/Ts);
t1=linspace(-Tau/2,Tau/2,N*D);
St_1=exp(2*j*pi*(F0*t1+0.5*K*t1.^2));
St_0=exp(2*j*pi*(+0.5*K*t1.^2));
N1=round(N*(1-D)/2);
zero=zeros(1,N1);%补零
St_0=[zero,St_0,zero];
St_1=[zero,St_1,zero];
St_0=awgn(St_0,SNRi);%加入噪声
St_1=awgn(St_1,SNRi);
%LFM时域波形
 figure(1);
 subplot(2,1,1)
 plot(real(St_0));
 title('LFM基带信号时域波形');
 grid on;axis tight;
%LFM频域波形
 figure(1);
 subplot(2,1,2)
 fftshift(abs(fft(St_0)));
 St_FFT_0=fftshift(abs(fft(St_0)));
 plot(St_FFT_0);
 title('LFM基带信号幅频特性');
 grid on;axis tight;
%中频信号时域
figure(2);
 subplot(2,1,1)
 plot(real(St_1));
 title('中频信号时域波形');
 grid on;axis tight;
%中频信号频域
 figure(2);
 subplot(2,1,2)
 fftshift(abs(fft(St_1)));
 St_FFT_1=fftshift(abs(fft(St_1)));
 plot(St_FFT_1);
 title('中频信号幅频特性');
 grid on;axis tight;
%***************匹配滤波*********************
Ht_0=fliplr(St_0);
Ht=conj(Ht_0);
Sot=conv(St_0,Ht);
Z0=abs(Sot);
%匹配滤波
 figure(3)
 subplot(2,1,1)
 plot(Z0);
 grid on;axis tight;
 title('脉冲压缩');
%匹配滤波dB
 figure(3)
 subplot(2,1,2)
Z1=20*log10(Z0);
 plot(Z1);
 grid on;axis tight;
 title('脉冲压缩（dB）');
