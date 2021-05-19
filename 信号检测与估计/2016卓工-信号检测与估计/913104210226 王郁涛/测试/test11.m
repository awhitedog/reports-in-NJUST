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
C=3e8;                              %����
Fs=4*B;Ts=1/Fs;                     %����Ƶ�ʺͲ�������
K=B/T;                              %��Ƶб��
Rw=Rmax-Rmin;                       %��෶Χ
Tw=2*Rw/C;                          
Num=ceil(Tw/Ts);                    %ÿ���������ڲ�������

%===========================����غ������=====================
t0=linspace(-T/20,T/20,Num/10);

St=exp(j*pi*K*t0.^2);               %��Ƶ�źű��ʽ
Ht=exp(-j*pi*K*t0.^2);

Z=zeros(1,round(0.45*Num));         %���㺯��
St=[Z,St,Z];                        %����ǰ����
Ht=[Z,Ht,Z];

Sot0=conv(St,Ht);                   %����غ���
figure(1)
subplot(211)
L=2*Num-1;
t1=linspace(-T,T,L);
Z0=abs(Sot0);
Z0=Z0/max(Z0);                      %��һ��
Z0=20*log10(Z0+1e-6);
t1=t1*B;                            %��һ��ʱ�䣬ʱ������
plot(t1,Z0);
%axis([-15,15,-50,inf]);
grid on;
legend('������');xlabel('��һ��ʱ�䣨t*B��');ylabel('����,dB');
title('����غ������');
subplot(212)                        %�Ŵ������
N1=5*Fs/B;
t2=-N1*Ts:Ts:N1*Ts;
t2=B*t2;
plot(t2,Z0(Num-N1:Num+N1));
axis([-inf,inf,-50,inf]);grid on;
set(gca,'Ytick',[-4,-1,0],'Xtick',[-6,-3,-1,-0.5,0,0.5,1,3,6]);xlabel('��һ��ʱ�䣨t*B��');ylabel('����,dB');
title('�Ŵ��������');

%===========================���ɻز��ź�=====================     
t=linspace(2*Rmin/C,2*Rmax/C,Num);                              
Nfft=2^nextpow2(Num+Num-1);                         %����ѹ��ʱfft����
Raw_data = zeros(N, Num);
Maiya = zeros(N, Num);
%---------����Ŀ��ز�
    td=t-2*R/C;
    t_yc=zeros(1,round(2*R/C/Ts));
    fdc=fd'*ones(1,Num);
    Srt=A*(exp(j*pi*K*td.^2 + j*2*pi*fdc*T));    %Ŀ��ز���Ƶ���ʽ
    Srt=[t_yc,Srt];
    Srt = awgn(Srt,SNR,'measured');                 %�����˹������
   
    figure(2)
    subplot(211)
    plot(t*1e6,real(Srt));
    axis tight;
    xlabel('ʱ�� /us');ylabel('����')
    title('����ѹ��ǰ���״�ز�');