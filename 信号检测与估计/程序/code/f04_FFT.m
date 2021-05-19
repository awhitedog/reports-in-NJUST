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
K=B/T;              %���Ե�Ƶб��
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
St=[zero,St_0,zero];
%***************�ز��ź�**********************
fd=2*V/(C/Fc);%������Ƶ��
i=1:N*(M+1);
St_Dop=exp(2*j*pi*fd*Ts*i);%��������ʱƵ���źŲ���
t_Delay=2*R/C;  %��ʱ
N_R=round(t_Delay/Ts);
zero_left=zeros(1,N1+N_R);
St_repeat=repmat(St,1,(M+1));
St_1=A*[zero_left,St_repeat];
St_1=St_1(:,1:(M+1)*N);
St_M=St_1.*St_Dop;%��������Ƶ�Ƶ��ź�
t_1=linspace(0,T,N);
St_M_Gauss=randn(1,N);%����������
 [filterB,filterA] = butter(12,0.05,'low');%20�׵�ͨ������˹�˲���
 [h,w]=freqz(filterB,filterA);
 St_M_Gauss=filter(filterB,filterA,randn(size(St_M)));
P_Ni=sum(St_M_Gauss.^2)/length(St_M_Gauss);
P_Si= P_Ni.*(10.^(SNRi/10));
St_M_without=sqrt(P_Si)*St_M;
St_M_with=St_M_without+St_M_Gauss;
%*************ƥ���˲�������ѹ����************
Ht_0=fliplr(St);
Ht=conj(Ht_0);
St_H_without=conv(St_M_without,Ht);
St_H_Gauss=conv(St_M_Gauss,Ht);
St_H_with=conv(St_M_with,Ht);
A_thero=10*log10(B*Tau*D)+10*log10(M);
SNRo_thero=A_thero+SNRi;
%*********************��������***********
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
xlabel('������');
ylabel('������');
title('����ѹ�����������ź���ź�');
%*******************FFT*********************
for h=1:N
St_fft_without(h,:)=abs(fft(St_fft_arrange_without(h,:)));
St_fft_Gauss(h,:)=abs(fft(St_fft_arrange_Gauss(h,:)));
St_fft_with(h,:)=abs(fft(St_fft_arrange_with(h,:)));
end
figure(5);
subplot(212);
mesh(1:M,1:N,(St_fft_with));
xlabel('������');
ylabel('������');
title('FFT����ź�');
A_So=max(max(St_fft_without));
P_So=A_So^2;
P_So_dB=10*log10(P_So);
P_No=sum(sum(St_fft_Gauss.^2))/(N*M);
P_No_dB=10*log10(P_No);
SNRo=P_So_dB-P_No_dB;
 