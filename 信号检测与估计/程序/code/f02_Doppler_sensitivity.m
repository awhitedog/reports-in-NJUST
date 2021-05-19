clc;
clear;
B=34e6;                 %����
T=200e-6;                 %ʱ��
D=10e-2;            %ռ�ձ�
Fc=10e9;            %��Ƶ
SNRi=-25;              %���������
V=0;              %Ŀ���ٶ�
A=1;               %Ŀ�����
R=0;            %Ŀ�����
tt=10e-3;           %��ɻ���ʱ��
%******************�������м����*******************
Tau=D*T;                %����
K=B/T;              %���Ե�Ƶб��
Fs=2*B;             %����Ƶ��
Ts=1/Fs;            %��������
C=3e8;              %����C
M=tt/T;             %�����ظ�����
%******************���Ե�Ƶ�ź�***************
N=round(T/Ts);
t1=linspace(-Tau/2,Tau/2,N*D);
t=linspace(-T/2,T/2,N);
St_0=exp(j*pi*K*t1.^2);
N1=round(N*(1-D)/2);
zero=zeros(1,N1);%����
St=[zero,St_0,zero];
%***************����ѹ��*********************
fd=2*V/(C/Fc);%������Ƶ��
i=1:N;
St_Dop=exp(2*j*pi*fd*Ts*(i-Tau/2/T*N));%��������ʱƵ���źŲ���
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
%����ѹ��ͼ��Ŵ�
 figure(3)
 plot(t2*1e6,Z1);
 axis([-1,1,0,70]);grid on;
 xlabel('ʱ�� ��λ��us');
 title('�ز��ź�����ѹ����dB��');
Z0=Z0/max(Z0);
Z2=20*log10(Z0);
%������ز���
range=double(-2*1e-6);[para1,para2] = find(t2<=range);
m_1_1=max(para2);
range=double(2*1e-6);[para1,para2] = find(t2<=range);
m_1_2=max(para2);
max_Main_Lobe=max(Z1(m_1_1:m_1_2));%����߶�
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
max_Side_Lobe=max([max_Side_Lobe_para1,max_Side_Lobe_para2]);%��һ�԰�
range=double(-4);[para1,para2] = find(Z2>=range);
m_1_1=max(para2);
m_1_2=min(para2);
max_4dB_Output_Pulse_Width=(t2(m_1_1)-t2(m_1_2))*1e9;%4dB�������
Main_lobe_side_lobe_ratio=max_Main_Lobe-max_Side_Lobe;%��ѹ���Ա�
