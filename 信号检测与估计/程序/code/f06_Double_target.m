clc;
clear;
B=34e6;                 %带宽
T=200e-6;               %周期
D=10e-2;            %占空比
Fc=10e9;            %载频
SNRi=-5;              %输入信噪比
V1=20;              %目标速度1
V2=22;           %速度2
A1=10;               %目标幅度
A2=3;            %目标幅度
tt=20e-3;           %相干积累时间
%******************常数或中间参数*******************
Tau=D*T;                %脉宽
K=B/T;              %线性调频斜率
fs=2*B;             %采样频率
Ts=1/fs;            %采样周期
C=3e8;              %光速C
M=tt/T;             %脉冲重复个数
%******************线性调频信号***************
R1=262;            %距离1
R2=262;          %距离2

N=round(T/Ts);
t1=linspace(-Tau/2,Tau/2,N*D);
t_0=linspace(-T/2,T/2,N);
St_0=exp(j*pi*K*t1.^2);
N1=round(N*(1-D)/2);
f=linspace(-fs/2,fs/2,N);
zero=zeros(1,N1);%补零
St=[zero,St_0,zero];
%***************回波信号**********************
St_repeat=repmat(St,1,M+1);
t_Delay1=2*R1/C;     t_Delay2=2*R2/C; %延时
N_R1=round(t_Delay1/Ts);N_R2=round(t_Delay2/Ts);
zero_left1=zeros(1,N1+N_R1);zero_left2=zeros(1,N1+N_R2);
St1=A1*[zero_left1,St_repeat];       St2=A2*[zero_left2,St_repeat];
St1=St1(:,1:(M+1)*N);    St2=St2(:,1:(M+1)*N);
fd1=2*V1/(C/Fc);     fd2=2*V2/(C/Fc);%多普勒频移
i=1:N*(M+1);
St_Dop1=exp(2*j*pi*fd1*Ts*i);       St_Dop2=exp(2*j*pi*fd2*Ts*i);%多普勒延时频移信号部分
St_M=St1.*St_Dop1+St2.*St_Dop2;%带多普勒频移的信号
 [filterB,filterA] = butter(12,0.05,'low');%20阶低通巴特沃斯滤波器
 [h,w]=freqz(filterB,filterA);
 St_M_Gauss=filter(filterB,filterA,randn(size(St_M)));
St_M_with=St_M+St_M_Gauss;
%*************匹配滤波（脉冲压缩）************
Ht_0=fliplr(St);
Ht=conj(Ht_0);
St_H_with=conv(St_M_with,Ht);
%*********************数据重排***********
 for r=1:M
for h=1:N
position=(r-1)*N+h+N*(1-D)/2;
St_fft_arrange_with(h,r)=St_H_with(position);
end
 end
%*******************FFT*********************
for h=1:N
St_fft_with(h,:)=(abs(fft(St_fft_arrange_with(h,:))));
end
%*******************数据抽取*****************
k=200;
for h=1:k
    St_fft_with_chose(h,:)=St_fft_with(h,:);
end

%*******************距离分辨率*************
% figure(6);
% subplot(211);
% mesh(1:M,1:k,(St_fft_with_chose));
% xlabel('距离门');
% ylabel('采样点');
% title(['距离差为',num2str(R2-R1),'m的情况']);
% figure(6);
% subplot(212);
% mesh(1:M,1:k,(St_fft_with_chose));
% view(-90,0);
% title(['距离投影']);

%*******************速度分辨率*************
% figure(7);
% subplot(211);
% mesh(1:M,1:k,(St_fft_with_chose));
% xlabel('距离门');
% ylabel('采样点');
% title(['速度差为',num2str(V2-V1),'m/s的情况']);
% figure(7);
% subplot(212);
% mesh(1:M,1:k,(St_fft_with_chose));
% view(0,0);
% title(['速度投影']);

%*******************遮盖*************
figure(8);
subplot(311);
mesh(1:M,1:k,(St_fft_with_chose));
xlabel('距离门');
ylabel('采样点');
title(['距离差',num2str(R2-R1),'m 速度差',num2str(V2-V1),'m/s']);
figure(8);
subplot(312);
mesh(1:M,1:k,(St_fft_with_chose));
view(-90,0);
title(['距离投影']);
figure(8);
subplot(313);
mesh(1:M,1:k,(St_fft_with_chose));
view(0,0);
title(['速度投影']);


 