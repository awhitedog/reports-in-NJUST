clc;
clear;
B=34e6;                 %带宽
T=200e-6;                 %周期
D=10e-2;            %占空比
Fc=10e9;            %载频
SNRi=-5;              %输入信噪比
V=0;              %目标速度
A=1;               %目标幅度
R=4000;            %目标距离
tt=15e-3;           %相干积累时间
%******************常数或中间参数*******************
Tau=D*T;                %脉宽
K=B/Tau;              %线性调频斜率
fs=2*B;             %采样频率
Ts=1/fs;            %采样周期
C=3e8;              %光速C
M=tt/T;             %脉冲重复个数
%******************线性调频信号***************
N=round(T/Ts);
t1=linspace(-Tau/2,Tau/2,N*D);
t_0=linspace(-T/2,T/2,N);
St_0=exp(j*pi*K*t1.^2);
N1=round(N*(1-D)/2);
f=linspace(-fs/2,fs/2,N);
zero=zeros(1,N1);%补零
St=[St_0,zero,zero];
St_repeat=repmat(St,1,M);
%***************回波信号**********************
fd=2*V/(C/Fc);%多普勒频移
i=1:N*M;
St_Dop=exp(2*j*pi*fd*Ts*i);%多普勒延时频移信号部分
i=1:N;
St_Dop1=exp(2*j*pi*fd*Ts*i);
t_Delay=2*R/C;  %延时
N_R=round(t_Delay/Ts);
zero_left=zeros(1,N_R);
zero_right=zeros(1,2*N1-N_R);
St1=A*[zero_left,St_0,zero_right];
St_00=A*[zero_left,St_repeat];
i=1:M*N;
St_1(i)=St_00(i);
St_M=St_1.*St_Dop;%带多普勒频移的信号
t_1=linspace(-Tau/2,T-Tau/2,N);
St_=St.*St_Dop1;
figure(1)
subplot(211);
plot(t_1*1E6,real(St_));
xlabel('时间 单位：us');
 title('LFM信号');
 grid on;axis tight;
subplot(212);
plot(t_1*1E6,real(St1));
xlabel('时间 单位：us');
 title(['延时为',num2str(t_Delay*1e6),'\mus的回波信号']);
 grid on;axis tight;
St_M_Gauss=randn(1,size(St_M,2))+j*randn(1,size(St_M,2));%产生白噪声
 [filterB,filterA] = butter(12,0.5,'low');%20阶低通巴特沃斯滤波器
 [h,w]=freqz(filterB,filterA);
 St_M_Gauss=filter(filterB,filterA,St_M_Gauss);
P_Ni=sum(abs(St_M_Gauss).^2)/length(St_M_Gauss);
P_Si= P_Ni.*(10.^(SNRi/10));
St_M_without=sqrt(P_Si)*St_M;
St_M_with=St_M_without+St_M_Gauss;
figure(11);
subplot(211);
plot(fftshift(abs(fft(St_M_Gauss))).^2);
title('滤波后的白噪声功率谱');
subplot(212);
plot(fftshift(abs(fft(St_M))).^2);
title('信号功率谱');
%*************匹配滤波（脉冲压缩）************
Ht_0=fliplr(St);
Ht=conj(Ht_0);
St_H_without=conv(St_M_without,Ht);
St_H_Gauss=conv(St_M_Gauss,Ht);
St_H_with=conv(St_M_with,Ht);
P_So=max(abs(St_H_without).^2);
P_So_dB=10*log10(P_So);
P_No=sum(abs(St_H_Gauss).^2)/length(St_H_Gauss);
P_No_dB=10*log10(P_No);
D_thero=10*log10(B*Tau);
SNRo_thero=D_thero+SNRi;
SNRo=P_So_dB-P_No_dB;
N2=N*M;
t_2=linspace(0,T*(M+1),N2);
N3=N*(M+1)-1;
t_3=linspace(0,T*(M+1),N3);
figure(2)
subplot(211);
plot(t_2*1E6,real(St_M_with));
xlabel('时间 单位：us');
 title('加入噪声的回波信号');
 grid on;axis tight;
subplot(212);
plot(t_3*1E6,real(St_H_with));
xlabel('时间 单位：us');
 title('脉冲压缩后的信号');
 grid on;axis tight;
 