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
K=B/T;              %线性调频斜率
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
St=[zero,St_0,zero];
%***************回波信号**********************
fd=2*V/(C/Fc);%多普勒频移
i=1:N*(M+1);
St_Dop=exp(2*j*pi*fd*Ts*i);%多普勒延时频移信号部分
t_Delay=2*R/C;  %延时
N_R=round(t_Delay/Ts);
zero_left=zeros(1,N1+N_R);
St_repeat=repmat(St,1,(M+1));
St_1=A*[zero_left,St_repeat];
St_1=St_1(:,1:(M+1)*N);
St_M=St_1.*St_Dop;%带多普勒频移的信号
t_1=linspace(0,T,N);
St_M_Gauss=randn(1,N);%产生白噪声
 [filterB,filterA] = butter(12,0.05,'low');%20阶低通巴特沃斯滤波器
 [h,w]=freqz(filterB,filterA);
 St_M_Gauss=filter(filterB,filterA,randn(size(St_M)));
P_Ni=sum(St_M_Gauss.^2)/length(St_M_Gauss);
P_Si= P_Ni.*(10.^(SNRi/10));
St_M_without=sqrt(P_Si)*St_M;
St_M_with=St_M_without+St_M_Gauss;
%*************匹配滤波（脉冲压缩）************
Ht_0=fliplr(St);
Ht=conj(Ht_0);
St_H_without=conv(St_M_without,Ht);
St_H_Gauss=conv(St_M_Gauss,Ht);
St_H_with=conv(St_M_with,Ht);
A_thero=10*log10(B*Tau*D)+10*log10(M);
SNRo_thero=A_thero+SNRi;
%*********************数据重排***********
 for r=1:M
for h=1:N
position=(r-1)*N+h+N*(1-D)/2;
St_fft_arrange_without(h,r)=St_H_without(position);
St_fft_arrange_Gauss(h,r)=St_H_Gauss(position);
St_fft_arrange_with(h,r)=St_H_with(position);
end
 end
figure(5);
subplot(211);
mesh(1:M,1:N,abs(real(St_fft_arrange_with)));
xlabel('距离门');
ylabel('采样点');
title('脉冲压缩、数据重排后的信号');
%*******************FFT*********************
for h=1:N
St_fft_without(h,:)=abs(fft(St_fft_arrange_without(h,:)));
St_fft_Gauss(h,:)=abs(fft(St_fft_arrange_Gauss(h,:)));
St_fft_with(h,:)=abs(fft(St_fft_arrange_with(h,:)));
end
figure(5);
subplot(212);
mesh(1:M,1:N,(St_fft_with));
xlabel('距离门');
ylabel('采样点');
title('FFT后的信号');
A_So=max(max(St_fft_without));
P_So=A_So^2;
P_So_dB=10*log10(P_So);
P_No=sum(sum(St_fft_Gauss.^2))/(N*M);
P_No_dB=10*log10(P_No);
SNRo=P_So_dB-P_No_dB;
 