clc;
clear;
B=10e6;             %����
T=5e-5;             %�����ظ�����
Tau=2e-6;           %����
Fc=16e9;            %��Ƶ
F0=7.5e6;
SNRi=30;            %���������
V=0;              %Ŀ���ٶ�
A=0.01;           %Ŀ�����
R=0;            %Ŀ�����
%******************�������м����*******************
D=Tau/T;            %ռ�ձ�
K=B/Tau;              %���Ե�Ƶб��
Fs=100e6;             %����Ƶ��
Ts=1/Fs;            %��������
C=3e8;              %����C
%******************���Ե�Ƶ�ź�***************
N=round(T/Ts);
t1=linspace(-Tau/2,Tau/2,N*D);
St_1=exp(2*j*pi*(F0*t1+0.5*K*t1.^2));
St_0=exp(2*j*pi*(+0.5*K*t1.^2));
N1=round(N*(1-D)/2);
zero=zeros(1,N1);%����
St_0=[zero,St_0,zero];
St_1=[zero,St_1,zero];
St_0=awgn(St_0,SNRi);%��������
St_1=awgn(St_1,SNRi);
%LFMʱ����
 figure(1);
 subplot(2,1,1)
 plot(real(St_0));
 title('LFM�����ź�ʱ����');
 grid on;axis tight;
%LFMƵ����
 figure(1);
 subplot(2,1,2)
 fftshift(abs(fft(St_0)));
 St_FFT_0=fftshift(abs(fft(St_0)));
 plot(St_FFT_0);
 title('LFM�����źŷ�Ƶ����');
 grid on;axis tight;
%��Ƶ�ź�ʱ��
figure(2);
 subplot(2,1,1)
 plot(real(St_1));
 title('��Ƶ�ź�ʱ����');
 grid on;axis tight;
%��Ƶ�ź�Ƶ��
 figure(2);
 subplot(2,1,2)
 fftshift(abs(fft(St_1)));
 St_FFT_1=fftshift(abs(fft(St_1)));
 plot(St_FFT_1);
 title('��Ƶ�źŷ�Ƶ����');
 grid on;axis tight;
%***************ƥ���˲�*********************
Ht_0=fliplr(St_0);
Ht=conj(Ht_0);
Sot=conv(St_0,Ht);
Z0=abs(Sot);
%ƥ���˲�
 figure(3)
 subplot(2,1,1)
 plot(Z0);
 grid on;axis tight;
 title('����ѹ��');
%ƥ���˲�dB
 figure(3)
 subplot(2,1,2)
Z1=20*log10(Z0);
 plot(Z1);
 grid on;axis tight;
 title('����ѹ����dB��');
