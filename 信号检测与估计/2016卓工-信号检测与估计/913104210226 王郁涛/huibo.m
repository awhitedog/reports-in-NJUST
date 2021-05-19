%%---���Ե�Ƶ�����״����
close all;
clear all;

%=========================ϵͳ����=========================
fc = 10e9;                          %�ز� 10GHz
C = 3e8;                            %����
l = C/fc;                           %�ز�����
T = 200e-6;                         %ʱ�� 200us,�����ظ����� 200us

B = 26e6;                           %��Ƶ���� 26MHz
Rmin = 0;Rmax = 30e3;               %��෶Χ
M = 50;                             %��ɻ���ʱ�䲻����10ms
SNR =-10;                           %�����
A = 1;                              %Ŀ�����
Fs=2*B;Ts=1/Fs;                     %����Ƶ�ʺͲ�������
K=B/T;                              %��Ƶб��
Rw=Rmax-Rmin;                       %��෶Χ
Tw=2*Rw/C;                          
N=round(T/Ts);                      %ÿ���������ڲ�������

%===========================�ز��ź�=====================
t0=linspace(-T/20,T/20,N/10);
yanchi=347;
z_left=zeros(1,4680+yanchi);
z_right=zeros(1,4680-yanchi);
St0=A*exp(j*pi*K*t0.^2);                %��Ƶ�źű��ʽ
Ht=A*exp(-j*pi*K*t0.^2);
sr0=[z_left,St0,z_right];             %�������޶����ջز��ź�
snr=-10;                              %�����
sr1=awgn(sr0,snr);
freq=linspace(-Fs/2,Fs/2,N);
figure(3)
subplot(211)
plot(freq*1e-6,fftshift(abs(fft(sr0))));
xlabel('f/ MHz');
axis tight;
title('�������ز��ķ�Ƶ����');
subplot(212)
plot(freq*1e-6,fftshift(abs(fft(sr1))));
xlabel('f/ MHz');
axis tight;
title('�������ز��ķ�Ƶ����');

v =10;                              %Ŀ���ٶ�
fd=2*v/l;                           %������Ƶ��

tt=linspace(-T/2,T/2,N);
st_fd=exp(j*2*pi*K*fd.*tt)          %������Ƶ���źŲ���
sr10=sr0.*st_fd;                    %������Ƶ���ź�
sr11=awgn(sr0,snr,'measured');      %�Ӹ�˹������
figure(4)
subplot(211)
plot(freq*1e-6,fftshift(abs(fft(sr10))));
xlabel('f/ MHz');
axis tight;
title('�����������ջز��ķ�Ƶ����');
subplot(212)
plot(freq*1e-6,fftshift(abs(fft(sr11))));
xlabel('f/ MHz');
axis tight;
title('�����������ջز��ķ�Ƶ����');


