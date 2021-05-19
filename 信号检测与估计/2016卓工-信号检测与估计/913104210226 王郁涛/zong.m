% Detection and Estimation
% wangyutao  913104210226


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
Fs=6*B;Ts=1/Fs;                     %����Ƶ�ʺͲ�������
K=B/T;                              %��Ƶб��
Rw=Rmax-Rmin;                       %��෶Χ
Tw=2*Rw/C;                          
Num=ceil(Tw/Ts);                    %ÿ���������ڲ�������

%===========================����غ������=====================
t0=linspace(-T/2,T/2,Num);

St=exp(j*pi*K*t0.^2);               %��Ƶ�źű��ʽ
Ht=exp(-j*pi*K*t0.^2);

Sot0=conv(St,Ht);                   %����غ���
figure(1)
subplot(211)
L=2*Num-1;
t1=linspace(-T,T,L);
Z0=abs(Sot0);
Z0=Z0/max(Z0);                      %��һ��
Z0=20*log10(Z0+1e-6);
t1=t1*B;
plot(t1,Z0);
axis([-15,15,-50,inf]);grid on;
legend('������');xlabel('��һ��ʱ�䣨t*B��');ylabel('����,dB');
title('����غ������');
subplot(212)                        %�Ŵ������
N1=5*Fs/B;
t2=-N1*Ts:Ts:N1*Ts;
t2=B*t2;
plot(t2,Z0(Num-N1:Num+N1));
axis([-inf,inf,-50,inf]);grid on;
set(gca,'Ytick',[-13.4,-4,0],'Xtick',[-3,-2,-1,-0.5,0,0.5,1,2,3]);xlabel('��һ��ʱ�䣨t*B��');ylabel('����,dB');
title('�Ŵ��������');

%===========================���ɻز��ź�=====================     
t=linspace(2*Rmin/C,2*Rmax/C,Num);                              
Nfft=2^nextpow2(Num+Num-1);                         %����ѹ��ʱfft����
Raw_data = zeros(N, Num);
Maiya_output = zeros(N, Num);
for ii = 1:N     
%---------����Ŀ��ز�
    td=t-2*R/C;
    fdc=fd'*ones(1,Num);
    Srt=A*(exp(j*pi*K*td.^2 + j*2*pi*fdc*ii*T));    %Ŀ��ز���Ƶ���ʽ
    Srt = awgn(Srt,SNR,'measured');                 %�����˹������
    Raw_data(ii,:) = Srt(:);                        %�洢�����ڻز�
    figure(2)
    subplot(211)
    plot(t*1e6,real(Srt));
    axis tight;
    xlabel('ʱ�� /us');ylabel('����')
    title('����ѹ��ǰ���״�ز�');
%---------------����ѹ��/ƥ���˲�
    Srw=fft(Srt,Nfft);                              %�ز�fft
    t0=linspace(-Tw/2,Tw/2,Num);
    St=exp(j*pi*K*t0.^2);                       
    Sw=fft(St,Nfft);                             
    Sot=fftshift(ifft(Srw.*conj(Sw)));              %Ƶ�����
    N0=Nfft/2-Num/2;   
    Z=Sot(N0:N0+Num-1);
    Maiya_output(ii,:) = Z(:);                      %�洢��ǰPRI �ڼ�����ѹ���Ľ��
    Z = abs(Z);
    Z=Z/max(Z);
    Z=20*log10(Z+1e-6);                             %����ѹ������һ����ת��Ϊdbֵ
    subplot(212)
    plot(t*C/2,Z)
    axis([Rmin,Rmax,-60,0]);
    xlabel('���� / m');ylabel('����/dB')
    title('����ѹ������״�ز�');
end

%===========================����������=====================
figure(3)
for i=1:Num
PR(i,1:50)=Maiya_output (i:Num:(N-1)*Num+i);
end
mesh(real(PR));  
title('����ѹ�������Ž��');

%===========================FFT����=====================
FFT_Output = fft(Maiya_output);  
FFT_Outputdb=20*log10(abs(FFT_Output));
fds = 1/T;                                          %�ظ�Ƶ��
doppler_bin = (0:N-1).*0.5*l*fds/N;                 
r = t*C/2;
figure(4)
mesh(r,doppler_bin,FFT_Outputdb);  
view(180,0)
xlabel('���� /m'); ylabel('Ŀ�꾶���ٶ� m/s');

title('FFT������');
figure(5)
contour(r,doppler_bin,FFT_Outputdb);  
xlabel('���� /m'); ylabel('Ŀ�꾶���ٶ� m/s');
title('FFT������ͶӰͼ');
