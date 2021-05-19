%%---���Ե�Ƶ�����״����
close all;
clear all;

%=========================ϵͳ����=========================
fc = 10e9;                          %�ز� 10GHz
c = 3e8;                            %����
l = c/fc;                           %�ز�����
T = 200e-6;                         %ʱ�� 200us,�����ظ����� 200us

B = 26e6;                           %��Ƶ���� 26MHz
Rmin = 0;Rmax = 30e3;               %��෶Χ
N = 50;                             %��ɻ���ʱ�䲻����10ms
SNR =-10;                           %�����
A = 1;                              %Ŀ�����
R = 1000;                           %Ŀ�����
vt =10;                             %Ŀ���ٶ�
fd = 2*vt/l;                        %��Ӧ�Ķ�����Ƶ��  

Fs=2*B;Ts=1/Fs;                     %����Ƶ�ʺͲ�������
K=B/T;                              %��Ƶб��
Rw=Rmax-Rmin;                       %��෶Χ
Tw=2*Rw/c;                          
Num=T/Ts;                    %ÿ���������ڲ�������

%=========================LFM=========================


t=linspace(-T/2,T/2,Num);
St=exp(j*pi*K*t.^2);                
subplot(211)
plot(t*1e6,real(St));
xlabel('t/us');
title('���Ե�Ƶ�ź�');
grid on;axis tight;
subplot(212)
freq=linspace(-Fs/2,Fs/2,Num);
plot(freq*1e-6,fftshift(abs(fft(St))));
xlabel('f/ MHz');
title('���Ե�Ƶ�źŵķ�Ƶ����');
grid on;axis tight;   



%==================LFM������غ���======================
T = 200e-6;                         %ʱ�� 200us,�����ظ����� 200us

B = 26e6;                           %��Ƶ���� 26MHz
K=B/T;                              %��Ƶб��
Fs=10*B;
Ts=1/Fs; 
N=T/Ts;
t=linspace(-T/2,T/2,N);
St=exp(j*pi*K*t.^2);               %��Ƶ�źű��ʽ
Ht=exp(-j*pi*K*t.^2);              %ƥ���˲��ź�
Sot=conv(St,Ht);
figure(2);
subplot(211);
L=2*N-1;
tt=linspace(-T,T,L);
Z=abs(Sot);
Z=Z/max(Z);                        %��һ��
Z=20*log10(Z+1e-6);
Z1=abs(sinc(B.*tt));               %sinc
Z1=20*log10(Z1+1e-6);
tt=tt*B;
plot(tt,Z,tt,Z1,'r.');
axis([-15,15,-50,inf]);
grid on;
legend('������','sinc');
xlabel('Time in sec\times\itB');ylabel('����,dB');
title('ƥ���˲�������Ե�Ƶ���');
subplot(212)                        %�Ŵ������
N0=3*Fs/B;
t2=-N0*Ts:Ts:N0*Ts;
t2=B*t2;
plot(t2,Z(N-N0:N+N0),t2,Z1(N-N0:N+N0),'r.');
axis([-inf,inf,-50,inf]);grid on;
set(gca,'Ytick',[-13.4,-4,0],'Xtick',[-3,-2,-1,-0.5,0,0.5,1,2,3]);         %��һ�԰�߶ȣ�4dB�������߶�
xlabel('��һ��ʱ�䣨t*B��');ylabel('����,dB');
title('�Ŵ��������');



