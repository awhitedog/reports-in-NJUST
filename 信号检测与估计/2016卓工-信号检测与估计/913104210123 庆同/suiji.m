%==================================================================
%�����趨
close all
clear all
T=200e-6;                          %ʱ��
B=23e6;                           %���Ե�Ƶ����
K=B/T;    
fc=10e9;                         %�״���Ƶ
Fs=5*B;Ts=1/Fs;                   %����Ƶ�ʺͲ�������
N=T/Ts;                           %ÿ���������ڲ�������
n=30;
v=10;                             %speed
c=3e8;
R=1000;                           %����
Rm=T*c/2;                         %�״�����������
fd=666.7                          %������Ƶ��
cita=1;                           %��Ŀ�����
Nfft=2^nextpow2(N+N-1);           %FFT��������
t=linspace(0,T,N);
St=exp(j*pi*K*t.^2);                 %����һ�����ڵ����Ե�Ƶ���ź�

SNR=input('please input SNR:');

%=======================˫Ŀ��==================================
cita = [1,1];   %% ����Ŀ��Ĺ�һ������
 v = [16,20];  %Ŀ�꾶���ٶ� m/s
 fd = 2*v/c*fc;  %��Ӧ�Ķ�����Ƶ��
 R=[8000,8000]; %����Ŀ�����

%==================================================================
Adata = zeros(n, N);           % �������������洢30��������        
Bdata = zeros(n, N); % �Ļز��źź���ѹ����ź�
Cdata=zeros(1,n);    %�������������ֵ
M=length(R);
A=sqrt(cita);         
%==================================================================

for i = 1:n 
      
%---------����Ŀ��ز�
td=ones(M,1)*t-2*R'/c*ones(1,N);
fdc=fd'*ones(1,N);
Stecho=A*(exp(j*pi*K*td.^2 + j*2*pi*fdc*i*T));%Ŀ��ز���Ƶ���ʽ
Stecho = awgn(Stecho,SNR,'measured');        %�����˹������
Adata(i,:) = Stecho(:);                      %�洢��ǰ֡�ز�

     Swecho=fft(Stecho,Nfft);                           %�ز�fft
     t0=linspace(-T/2,T/2,N);
     St=exp(j*pi*K*t0.^2);                       
     Sw=fft(St,Nfft);                             
     Stmy=fftshift(ifft(Swecho.*conj(Sw)));              %Ƶ�����
 %=========================================================
    N0=(Nfft-N)/2;

    ZZ=Stmy(N0:N0+N-1);
    Bdata(i,:) = ZZ(:);   %%�洢��ǰPRI �ڼ�����ѹ���Ľ��
    
    Cdata(1,i)=max(abs(ZZ));
    zz=abs(ZZ);
    zz=zz/max(zz);
    zz=20*log10(zz);
    zmax(1,i)=max(zz);
    zmean(1,i)=mean(zz);
    
   
  st=exp(j*pi*K*t0.^2);%��Ƶ�źű��ʽ  
  Ht=exp(-j*pi*K*t0.^2);%ƥ���˲���
  Stme=conv(st,Ht);%�źž���ƥ���˲���
  figure(3)
  subplot(211)
  L=2*N-1;
  t1=linspace(-T,T,L);
  Z=abs(Stme);
  Z=Z/max(Z);%��һ��
  Z=20*log10(Z+1e-6);
  Z1=abs(sinc(B.*t1));%���˺���
  Z1=20*log10(Z1+1e-6);
  t1=t1*B;
  plot(t1,Z,t1,Z1,'k.');
  axis([-15,15,-50,inf]);grid on;
  legend('������','���˺���');xlabel('��һ��ʱ�䣨t*B��');ylabel('����,dB');
  title('ƥ���˲�����ź�');
  subplot(212)%�Ŵ������
   N0=3*Fs/B;
  t2=-N0*Ts:Ts:N0*Ts;
  t2=B*t2;
  plot(t2,Z(N-N0:N+N0),t2,Z1(N-N0:N+N0),'r.');
  axis([-inf,inf,-50,inf]);grid on;
  set(gca,'Ytick',[-13.4,-4,0],'Xtick',[-3,-2,-1,-0.5,0,0.5,1,2,3]);xlabel('��һ��ʱ�䣨t*B��');ylabel('����,dB');
  title('�Ŵ���ƥ���˲��ź�');
end
 figure(1)
    subplot(211)
    plot(t*1e6,real(Stecho));
    axis tight;
    xlabel('ʱ�� /us');ylabel('����')
    title('����ѹ��ǰ���״�ز�');
    subplot(212)
    plot(t*c/2,zz)
    axis([0,Rm,-60,0]);%����������
    xlabel('���� / m');ylabel('����/dB')
    title('����ѹ������״�ز�');
figure(2)
rbin = t*c/2;
pribin = 1:n;
mesh(rbin,pribin,abs(Bdata));  %%
xlabel('���� /m'); ylabel('�����ظ�����');
title('����ѹ�����������Ž��');
%%--------- FFT ����-----------
FFT_Output = fft(Bdata);  
FFT_Outputdb=20*log10(abs(FFT_Output));
fds = 1/T;      
doppler_bin = (0:n -1).*0.5*c/fc*fds/n;  %
rbin = t*c/2;
figure(4)
mesh(rbin,doppler_bin,FFT_Outputdb);  
xlabel('���� /m'); ylabel('Ŀ�꾶���ٶ� m/s');
title('FFT������');
figure(5)
contour(rbin,doppler_bin,FFT_Outputdb);  
xlabel('���� /m'); ylabel('Ŀ�꾶���ٶ� m/s');
title('FFT������ͼ');

Zmax=mean(zmax);
Zmean=mean(zmean);
disp(Zmax-Zmean);

%figure(6)
%plot(500*(1:n),Cdata);
%axis tight;
%figure(6)
%xlabel('Time in u sec');
%title('Real part of chirp signal');
%freq=linspace(0,Fs,N);
%plot(freq*1e-6,fftshift(abs(fft(St))));
%xlabel('Frequency in MHz');
%title('Magnitude spectrum of chirp signal');
%grid on;axis tight;