clc;
clear;
B=34e6;                 %����
T=200e-6;                 %����
D=10e-2;            %ռ�ձ�
Fc=10e9;            %��Ƶ
SNRi=-5;              %���������
V=0;              %Ŀ���ٶ�
A=1;               %Ŀ�����
R=4000;            %Ŀ�����
tt=15e-3;           %��ɻ���ʱ��
%******************�������м����*******************
Tau=D*T;                %����
K=B/Tau;              %���Ե�Ƶб��
fs=2*B;             %����Ƶ��
Ts=1/fs;            %��������
C=3e8;              %����C
M=tt/T;             %�����ظ�����
%******************���Ե�Ƶ�ź�***************
N=round(T/Ts);
t1=linspace(-Tau/2,Tau/2,N*D);
t_0=linspace(-T/2,T/2,N);
St_0=exp(j*pi*K*t1.^2);
N1=round(N*(1-D)/2);
f=linspace(-fs/2,fs/2,N);
zero=zeros(1,N1);%����
St=[St_0,zero,zero];
St_repeat=repmat(St,1,M);
%***************�ز��ź�**********************
fd=2*V/(C/Fc);%������Ƶ��
i=1:N*M;
St_Dop=exp(2*j*pi*fd*Ts*i);%��������ʱƵ���źŲ���
i=1:N;
St_Dop1=exp(2*j*pi*fd*Ts*i);
t_Delay=2*R/C;  %��ʱ
N_R=round(t_Delay/Ts);
zero_left=zeros(1,N_R);
zero_right=zeros(1,2*N1-N_R);
St1=A*[zero_left,St_0,zero_right];
St_00=A*[zero_left,St_repeat];
i=1:M*N;
St_1(i)=St_00(i);
St_M=St_1.*St_Dop;%��������Ƶ�Ƶ��ź�
t_1=linspace(-Tau/2,T-Tau/2,N);
St_=St.*St_Dop1;
figure(1)
subplot(211);
plot(t_1*1E6,real(St_));
xlabel('ʱ�� ��λ��us');
 title('LFM�ź�');
 grid on;axis tight;
subplot(212);
plot(t_1*1E6,real(St1));
xlabel('ʱ�� ��λ��us');
 title(['��ʱΪ',num2str(t_Delay*1e6),'\mus�Ļز��ź�']);
 grid on;axis tight;
St_M_Gauss=randn(1,size(St_M,2))+j*randn(1,size(St_M,2));%����������
 [filterB,filterA] = butter(12,0.5,'low');%20�׵�ͨ������˹�˲���
 [h,w]=freqz(filterB,filterA);
 St_M_Gauss=filter(filterB,filterA,St_M_Gauss);
P_Ni=sum(abs(St_M_Gauss).^2)/length(St_M_Gauss);
P_Si= P_Ni.*(10.^(SNRi/10));
St_M_without=sqrt(P_Si)*St_M;
St_M_with=St_M_without+St_M_Gauss;
figure(11);
subplot(211);
plot(fftshift(abs(fft(St_M_Gauss))).^2);
title('�˲���İ�����������');
subplot(212);
plot(fftshift(abs(fft(St_M))).^2);
title('�źŹ�����');
%*************ƥ���˲�������ѹ����************
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
xlabel('ʱ�� ��λ��us');
 title('���������Ļز��ź�');
 grid on;axis tight;
subplot(212);
plot(t_3*1E6,real(St_H_with));
xlabel('ʱ�� ��λ��us');
 title('����ѹ������ź�');
 grid on;axis tight;
 