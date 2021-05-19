clc;
clear;
B=34e6;                 %带宽
T=200e-6;                 %时宽
D=10e-2;            %占空比
Fc=10e9;            %载频
SNRi=-25;              %输入信噪比
V=0;              %目标速度
A=1;               %目标幅度
R=0;            %目标距离
tt=10e-3;           %相干积累时间
%******************常数或中间参数*******************
Tau=D*T;                %脉宽
K=B/T;              %线性调频斜率
Fs=2*B;             %采样频率
Ts=1/Fs;            %采样周期
C=3e8;              %光速C
M=tt/T;             %脉冲重复个数
%******************线性调频信号***************
N=round(T/Ts);
t1=linspace(-Tau/2,Tau/2,N*D);
t=linspace(-T/2,T/2,N);
St_0=exp(j*pi*K*t1.^2);
N1=round(N*(1-D)/2);
zero=zeros(1,N1);%补零
St=[zero,St_0,zero];
%***************脉冲压缩*********************
fd=2*V/(C/Fc);%多普勒频移
i=1:N;
St_Dop=exp(2*j*pi*fd*Ts*(i-Tau/2/T*N));%多普勒延时频移信号部分
t_Delay=2*R/C;
N_R=round(t_Delay/Ts);
zero_left=zeros(1,N1+N_R);
zero_right=zeros(1,N1-N_R);
St1=A*[zero_left,St_0,zero_right];
St_M=St1.*St_Dop;
Ht_0=fliplr(St);
Ht=conj(Ht_0);
Sot=conv(St_M,Ht);
N2=2*N-1;
t2=linspace(-T,T,N2);
Z0=abs(Sot);
Z1=20*log10(Z0);
%脉冲压缩图像放大
 figure(3)
 plot(t2*1e6,Z1);
 axis([-1,1,0,70]);grid on;
 xlabel('时间 单位：us');
 title('回波信号脉冲压缩后（dB）');
Z0=Z0/max(Z0);
Z2=20*log10(Z0);
%查找相关参数
range=double(-2*1e-6);[para1,para2] = find(t2<=range);
m_1_1=max(para2);
range=double(2*1e-6);[para1,para2] = find(t2<=range);
m_1_2=max(para2);
max_Main_Lobe=max(Z1(m_1_1:m_1_2));%主瓣高度
range=double(0.3*1e-6);[para1,para2] = find(t2<=range);
m_1_1=max(para2);
range=double(0.6*1e-6);[para1,para2] = find(t2<=range);
m_1_2=max(para2);
max_Side_Lobe_para1=max(Z1(m_1_1:m_1_2));
range=double(-0.6*1e-6);[para1,para2] = find(t2<=range);
m_1_1=max(para2);
range=double(-0.3*1e-6);[para1,para2] = find(t2<=range);
m_1_2=max(para2);
max_Side_Lobe_para2=max(Z1(m_1_1:m_1_2));
max_Side_Lobe=max([max_Side_Lobe_para1,max_Side_Lobe_para2]);%第一旁瓣
range=double(-4);[para1,para2] = find(Z2>=range);
m_1_1=max(para2);
m_1_2=min(para2);
max_4dB_Output_Pulse_Width=(t2(m_1_1)-t2(m_1_2))*1e9;%4dB输出带宽
Main_lobe_side_lobe_ratio=max_Main_Lobe-max_Side_Lobe;%脉压主旁比
