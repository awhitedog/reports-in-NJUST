clc;
clear;
B=34e6;                 %����
T=200e-6;                 %����
D=10e-2;            %ռ�ձ�
Fc=10e9;            %��Ƶ
SNRi=-25;              %���������
V=0;              %Ŀ���ٶ�
A=3;               %Ŀ�����
R=0;            %Ŀ�����
tt=10e-3;           %��ɻ���ʱ��
%******************�������м����*******************
Tau=D*T;                %����
K=B/Tau;              %���Ե�Ƶб��
Fs=2*B;             %����Ƶ��
Ts=1/Fs;            %��������
C=3e8;              %����C
M=tt/T;             %�����ظ�����
%******************���Ե�Ƶ�ź�***************
N=round(T/Ts);
t1=linspace(-Tau/2,Tau/2,N*D);
t=linspace(-T/2,T/2,N);
St_0=exp(2*j*pi*(+0.5*K*t1.^2));
N1=round(N*(1-D)/2);
zero=zeros(1,N1);%����
St=[zero,St_0,zero];
%LFMʱ����
 figure(1);
 subplot(2,1,1)
 plot(t*1e6,real(St));
 xlabel('ʱ�� ��λ��us');
 title('���Ե�Ƶ�ź�ʱ����');
 grid on;axis tight;
%LFMƵ����
 f=linspace(-Fs/2,Fs/2,N);
 figure(1);
 subplot(2,1,2)
 fftshift(abs(fft(St)));
 St_FFT=fftshift(abs(fft(St)));
 plot(f*1e-6,St_FFT);
 xlabel('Ƶ�� ��λ��MHz');
 title('���Ե�Ƶ�źŷ�Ƶ����');
 grid on;axis tight;
%***************����غ���*********************
Ht_0=fliplr(St);
Ht=conj(Ht_0);
Sot=conv(St,Ht);
N2=2*N-1;
t2=linspace(-T,T,N2);
Z0=abs(Sot);
%����غ���
 figure(2)
 subplot(2,1,1)
 plot(t2*1e6,Z0);
 axis([-21,21,-inf,inf]);grid on;
 xlabel('ʱ�� ��λ��us');
 title('����غ���');
%����غ���dB
 figure(2)
 subplot(2,1,2)
Z1=20*log10(Z0);
 plot(t2*1e6,Z1);
 axis([-21,21,-inf,inf]);grid on;
 xlabel('ʱ�� ��λ��us');
 title('����غ�����dB��');
%����غ����Ŵ�
 figure(3)
 subplot(2,1,1)
 plot(t2*1e6,Z1);
 axis([-1,1,-5,70]);grid on;
 xlabel('ʱ�� ��λ��us');
 title('����غ�����dB��');
%����غ����Ŵ�2
 figure(3)
 subplot(2,1,2)
Z0=Z0/max(Z0);
Z2=20*log10(Z0);
 plot(t2*1e6,Z2);
 axis([-1,1,-5,1]);grid on;
 xlabel('ʱ�� ��λ��us');
 title('����غ�������һ����');
%��������غ�������
 t_find=linspace(-0.6e-6,0.6e-6,N*100);%��ֵ��Χ
 Z_1=interp1(t2,Z1,t_find,'linear'); %�ڲ�ֵ
 Z_2=interp1(t2,Z2,t_find,'linear'); %�ڲ�ֵ
 range=double(-0.2*1e-6);[para1,para2] = find(t_find<=range);
 m_1_1=max(para2);
 range=double(0.2*1e-6);[para1,para2] = find(t_find<=range);
 m_1_2=max(para2);
 max_Main_Lobe=max(Z_1(:));%����߶�
 range=double(0.3*1e-6);[para1,para2] = find(t_find<=range);
 m_1_1=max(para2);
 range=double(0.6*1e-6);[para1,para2] = find(t_find<=range);
 m_1_2=max(para2);
 max_Side_Lobe=max(Z_1(m_1_1:m_1_2));%��һ�԰�
 Main_lobe_side_lobe_ratio=max_Main_Lobe-max_Side_Lobe;%�����԰��
 range=double(-4);[para1,para2] = find(Z_2>=range);
 m_1_1=max(para2);
 m_1_2=min(para2);
 max_4dB_Output_Pulse_Width=(t_find(m_1_1)-t_find(m_1_2))*1e9;%4dB�������

%  range=double(-0.2*1e-6);[para1,para2] = find(t2<=range);
%  m_1_1=max(para2);
%  range=double(0.2*1e-6);[para1,para2] = find(t2<=range);
%  m_1_2=max(para2);
%  max_Main_Lobe=max(Z1(:));%����߶�
%  range=double(0.3*1e-6);[para1,para2] = find(t2<=range);
%  m_1_1=max(para2);
%  range=double(0.6*1e-6);[para1,para2] = find(t2<=range);
%  m_1_2=max(para2);
%  max_Side_Lobe=max(Z1(m_1_1:m_1_2));%��һ�԰�
%  Main_lobe_side_lobe_ratio=max_Main_Lobe-max_Side_Lobe;%�����԰��
%  range=double(-4);[para1,para2] = find(Z2>=range);
%  m_1_1=max(para2);
%  m_1_2=min(para2);
%  max_4dB_Output_Pulse_Width=(t2(m_1_1)-t2(m_1_2))*1e9;%4dB�������

