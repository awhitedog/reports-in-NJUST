%%---���Ե�Ƶ�����״����
close all;
clear all;

%=========================ϵͳ����=========================
fc = 10e9;                          %�ز� 10GHz
C = 3e8;                            %����
l = C/fc;                           %�ز�����
T = 200e-6;                         %ʱ�� 200us,�����ظ����� 200us

B = 26e6;                           %��Ƶ���� 26MHz
M = 50;                             %��ɻ���ʱ�䲻����10ms
SNR =-10;                           %�����
A = 1;                              %Ŀ�����
Fs=2*B;Ts=1/Fs;                     %����Ƶ�ʺͲ�������
K=B/T;                              %��Ƶб��
                        
N=round(T/Ts);                      %ÿ���������ڲ�������


%============================LFM=============================
t0=linspace(-T/20,T/20,N/10);
t00=linspace(-T/2,T/2,N);
freq=linspace(-Fs/2,Fs/2,N);

z_left0=zeros(1,4680);
z_right0=zeros(1,4680);
St0=A*exp(j*pi*K*t0.^2);                    %��Ƶ�źű��ʽ
St1=[z_left0,St0,z_right0];                 %��Ƶ�źű��ʽ����  
figure(1)
subplot(211)
plot(t00*1e6,real(St1));                    %LFMʱ��
xlabel('t/us');
title('���Ե�Ƶ�ź�');
grid on;axis tight;
subplot(212)
freq=linspace(-Fs/2,Fs/2,N);
plot(freq*1e-6,fftshift(abs(fft(St1))));    %LFM��Ƶ���� 
xlabel('f/ MHz');
title('���Ե�Ƶ�źŵķ�Ƶ����');
grid on;axis tight;   






%===========================����غ������=====================
t0=linspace(-T/20,T/20,N/10);
z_left0=zeros(1,4680);
z_right0=zeros(1,4680);
St0=A*exp(j*pi*K*t0.^2);                %��Ƶ�źű��ʽ
Ht0=A*exp(-j*pi*K*t0.^2);

St1=[z_left0,St0,z_right0];            %��Ƶ�źű��ʽ����  
Ht1=[z_left0,Ht0,z_right0];

Sot0=conv(St1,Ht1);                   %����غ���
figure(2)
subplot(211)
L=2*N-1;
t1=linspace(-T,T,L);
Z0=abs(Sot0);
Z0=Z0/max(Z0);                      %��һ��
Z0=20*log10(Z0+1e-6);
t1=t1*B;
plot(t1,Z0);
axis([-30,30,-50,inf]);grid on;
legend('������');xlabel('��һ��ʱ�䣨t*B��');ylabel('����,dB');
title('����غ������');
subplot(212)                        %�Ŵ������
N1=10*Fs/B;
t2=-N1*Ts:Ts:N1*Ts;
t2=B*t2;
plot(t2,Z0(N-N1:N+N1));
axis([-inf,inf,-50,inf]);grid on;
set(gca,'Ytick',[-13.4,-4,0],'Xtick',[-5,-3,-1,-0.5,0,0.5,1,3,5]);xlabel('��һ��ʱ�䣨t*B��');ylabel('����,dB');
title('�Ŵ��������');
