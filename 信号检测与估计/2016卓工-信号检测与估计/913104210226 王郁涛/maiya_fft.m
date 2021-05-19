close all;
clear all;

%=========================ϵͳ����=========================
fc = 10e9;                          %�ز� 10GHz
C = 3e8;                            %����
l = C/fc;                           %�ز�����
T = 200e-6;                         %ʱ�� 200us,�����ظ����� 200us
B = 26e6;                           %��Ƶ���� 26MHz
M = 50;                             %��ɻ���ʱ�䲻����10ms
snr =-10;                           %�����
A = 1;                              %Ŀ�����
Fs=2*B;Ts=1/Fs;                     %����Ƶ�ʺͲ�������
K=B/T;                              %��Ƶб��                     
N=round(T/Ts);                      %ÿ���������ڲ�������

Rmin=0;Rmax=20e3;                   %���������min��max
Rw=Rmax-Rmin;
Tw=2*Rw/C;                          
Num=ceil(Tw/Ts);                    %ÿ���������ڲ�������
v =10;                              %Ŀ���ٶ�
fd=2*v/l;                           %������Ƶ��

t=linspace(2*Rmin/C,2*Rmax/C,Num);                              
Nfft=2^nextpow2(2*N-1);                         %����ѹ��ʱfft������Ƶ���������L>M+N-1,��Ȼ������
Raw_data = zeros(M, N);
Maiya = zeros(M, N);

for ii = 1:M     
%---------------���췢���źźͻز��ź�
t0=linspace(-T/20,T/20,N/10);
t00=linspace(-T/2,T/2,N);
freq=linspace(-Fs/2,Fs/2,N);

z_left0=zeros(1,4680);
z_right0=zeros(1,4680);
yanchi=347;
z_left=zeros(1,4680+yanchi);
z_right=zeros(1,4680-yanchi);


St0=A*exp(j*pi*K*t0.^2);                    
St1=[z_left0,St0,z_right0];                        %�����ź�  

sr0=[z_left,St0,z_right];                          %�������޶����ջز��ź�
st_fd=exp(j*2*pi*K*fd.*t00) ;                      %������Ƶ���źŲ���
sr10=sr0.*st_fd;                                   %������Ƶ���ź�
sr11=awgn(sr0,snr,'measured');                     %�ز��źżӸ�˹������


   
%---------------����ѹ��/ƥ���˲�
    Srw=fft(sr11,Nfft);                             %�ز�fft
    Sw=fft(St1,Nfft);                                %�����ź�fft
    Sot=fftshift(ifft(Srw.*conj(Sw)));              %Ƶ�����
    N0=Nfft/2-N/2;   
    Z=Sot(N0:N0+N-1);
    Maiya(ii,:) = Z(:);                             %�洢��ǰPRI �ڼ�����ѹ���Ľ��
    Z = abs(Z);
    Z=Z/max(Z);
    Z=20*log10(Z+1e-6);                             %����ѹ������һ����ת��Ϊdbֵ
    figure(5)
    plot(t00*C/2,Z)
    axis([Rmin,Rmax,-60,0]);
    xlabel('���� / m');ylabel('����/dB')
    title('����ѹ������״�ز�');
end

%===========================����������=====================
figure(6)

for i=1:N
PR(i,1:50)=Maiya(i:N:(M-1)*N+i);             %������
end
mesh(real(PR));  
title('����ѹ�������Ž��');

%===========================FFT����=====================
FFT_Output = fft(Maiya);  
FFT_Outputdb=20*log10(abs(FFT_Output));
fds = 1/T;                                          %�ظ�Ƶ��
vt = (0:M-1).*0.5*l*fds/M;                          %����Ŀ�꾶���ٶ�v=fd*l*0.5
figure(7)
r = t00*C/2;
mesh(r,vt,FFT_Outputdb);  
view(180,0)
xlabel('���� /m'); ylabel('Ŀ�꾶���ٶ� m/s');
title('FFT������');
figure(8)
contour(r,vt,FFT_Outputdb);  
xlabel('���� /m'); ylabel('Ŀ�꾶���ٶ� m/s');
title('FFT������ͶӰͼ');

