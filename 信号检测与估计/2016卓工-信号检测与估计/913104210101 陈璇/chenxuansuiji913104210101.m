%----------------------------�źż���������ҵ-----------------------------%
%-----------------------����α�����λ�����������״���źŴ���---------------%
%-----------------------------913104210101--------------------------------%
%---------------------------------���------------------------------------%
%-----------------------------ָ����ʦ���˺�-------------------------------%

close all;
clear;                 
clc;                  

%% --------------------------�����趨--------------------------- %%
n=7;                                                                       %����
fm=1e6;                                                                    %��ƵΪѧ��ĩ��λ��01������ƵΪ1MHz
mc=2^n-1;                                                                  %�볤Ϊ127
fc=10e9;                                                                   %�״���ƵΪ10GHz    
snr=-15;                                                                   %Ŀ��ز���������ȣ�-35dB��10dB��
V1=0;                                                                      %Ŀ��1�ٶȿɱ䣨0��1000m/s��
V2=0;                                                                      %Ŀ��2�ٶȿɱ䣨0��1000m/s�� 
c=3e8;                                                                     %����
A0=1;                                                                      %�����źŵķ���
A1=10;                                                                     %Ŀ��1�ķ��ȿɱ䣨1��100��
A2=80;                                                                     %Ŀ��2�ķ��ȿɱ䣨1��100��
D1=2000;                                                                   %Ŀ��1�ľ���ɱ䣨0��10000m��
D2=1500;                                                                   %Ŀ��2�ľ���ɱ䣨0��10000m��
tr1=2*D1/c;                                                                %�״ﲨ��Ŀ��1�ز�����ʱ
tr2=2*D2/c;                                                                %�״ﲨ��Ŀ��2�ز�����ʱ
fd1=2*V1*fc/c;                                                             %Ŀ��1�Ķ�����Ƶƫ
fd2=2*V2*fc/c;                                                             %Ŀ��2�Ķ�����Ƶƫ
txg=10e-3;                                                                 %��ɻ�����ʱ�� 
N=78;                                                                      %����ʱ�䲻����10ms��N<t/T=78.74,����Nȡ78 T=1/fm*127;
dfenbian=c/2/fm;                                                           %����ֱ������˴�������Ϊ150  
fdrx=1/2/mc*fm;                                                            %����������,�˴�Ϊ3937hz,��Ӧ�ٶ�60m/s
Rmax=N/fm*c/2;                                                             %������þ���
vfebian=1*fm*c/fc/2/mc/N;                                                  %�ٶȷֱ���Ϊ1.5142m/s


%% -------------------------- m���в���------------------------- %%
m_127=zeros(1,2^n-1);                                                      %m���г�ʼ��
choutou= [fix(n/2)+1,n];                                                   %���巴�������ĳ�ͷλ��,fix��βȡ��
xishu(choutou) = 1;                                                        %���������ͷ���ڴ�Ϊһ
xishu=xishu';                                                              %��ϵ��ת��
register=[0,1,0,1,0,1,0];                                                  %����Ĵ�����ʼ״̬������ȫΪ��
for i=1:2^n-1                           
    m_127(1,i) =1- 2*register(n);                                          % �����һ���㣨ʮ���ƣ�  
    weishu = mod(register*xishu,2);                                        % ģ2����
    register(2:n) = register(1:n-1);                                       % �ڶ�λ�����һλ��λ����
    register(1)=weishu;                                                    % ģ���Ľ��������һλ
end

%% ---------------------------m���������----------------------- %%
msequence=repmat(m_127,1,N);                                               %�����ɵ�127λm���н�����������
a = msequence(1:end) ;                                                     %���ɾ���ռ�
b = m_127 ;                       
c = zeros(500,1) ;
for i = 1:500
    c(i) = b*a(i:i+126)' ;
end
figure(1),plot(c/127);
title('m���������');

%% --------------------------�����ź�--------------------------- %%
fc1=2e6;                                                                   %Ϊ�˻�ͼ�ķ��㣬�˴�����Ƶ��Ϊ2MHz
Fs=8e6;                                                                    %����Ƶ��Ϊ8MHz                 
mf=repmat(m_127,1,1);
mf=mf(1:4);
T=length(mf)*10e-6;
B=[];
for i=1:4
    if mf(i)==1
        BB=ones(1,80);
        B=[B,BB];
    else
        BB=-1*ones(1,80);
        B=[B,BB];
    end
end

Ts=1/Fs;                                                                   %�������
nn=T/Ts;                                                                   %ʱ�����г���  
t=linspace(0,T,nn);
i=1:320;
f=cos(2*pi*fc*t);
sf=A0*B.*sin(2*pi*fc*t);
figure(8),subplot(3,1,1),plot(i,B);
subplot(3,1,2),plot(t,f);
subplot(3,1,3),plot(t,sf);

%% *************************��Ŀ��****************************** %%

%% -------------------------�ز��ź�---------------------------- %%
n_delay1=fix(tr1*fm);                                                      %�ӳٵ���Ԫ����,tr1Ϊ�״ﲨ��Ŀ��1�ز�����ʱ��fmΪ��Ƶ
m_delay1=zeros(1,mc);                                                      %m_delayΪ�ز��ĵ�����m���У����ɾ���ռ�
m_delay1(1:n_delay1)=m_127(mc-n_delay1+1:mc);                              %ǰ������ԭm���еĺ󼸸�
m_delay1(n_delay1+1:mc)=m_127(1:mc-n_delay1);                              %�󼸸���ԭm���е�ǰ����
mr1=repmat(m_delay1,1,N);                                                  %�����m���У��ӳ�n_delay����Ԫ��������Ŀ�������Ϣ
j1=1:mc*N;                                                                 %�Ա���                                                              
sr1=A1*mr1.*cos(2*pi*fd1*j1/fm);                                           %Ŀ��1�Ļز��ź�                                          
sr1_snr=awgn(sr1,snr,'measured');                                          %�����Ϊsnr,awgnָ���Ը�˹������
j11=1:mc; 
sr11=A1*m_delay1.*cos(2*pi*fd1*j11/fm);  
sr11_snr=awgn(sr11,snr,'measured');
P_signal=A1*A1;
noise=sr1_snr-sr1;
E_noise=0;
for i=1:mc*N
    E_noise=E_noise+noise(i)*noise(i);
end
P_noise=E_noise/(mc*N)                                                     %ƽ����������
SNR1=10*log10(P_signal/P_noise)                                            %�ŵ�������֤
%figure(9),plot(j1,sr1);

%% -------------------------��ѹ------------------------------- %%
k1=fliplr(m_127);                                  
my1=conv(sr1_snr,k1);                                                      %����ѹ������
signal=conv(sr1,k1);
noise=my1-signal;
E_signal=0;
for i=1:mc*N+126
    E_signal=E_signal+signal(i)*signal(i);
end
P_signal=E_signal/(mc*N+126)
% E_noise=0;
% for i=1:mc*N+126
%     E_noise=E_noise+noise(i)*noise(i);
% end
% P_noise=E_noise/(mc*N+126) 
SNR2=10*log10(P_signal/P_noise)
my11=conv(sr11_snr,k1);
%my11=20*log10(my1);
figure(2),subplot(2,1,1),plot(abs(my1));                                   %������ѹ��Ĳ���  
title('��Ŀ�����������ѹ����Ĳ���');
subplot(2,1,2),plot(abs(my11))
title('��Ŀ�굥��������ѹ����Ĳ���');

[maxa,quwei]=max(my1);                                                     %��ʱ��
for i=1:5
    y(i)=20*log10(my1(i+quwei-3));
end
x=1:5                                                                     
xi=1:1/360:5;
yi=interp1(x,y,xi,'cubic');                                                %���ڲ庯��
figure(9),plot(x,y,'o',xi,yi);                                             %ͼ9��ʾʱ��
title('ʱ��');
%% ----------------------- -FFT-------------------------------- %%
for r=1:N    
    for h=1:mc        
        cp1(h,r)=my1((r-1)*mc+h);     
    end
end
cp1=cp1';
cp1=[cp1,zeros(78,1)];
cp1=cp1';
%figure(3),mesh(1:N,1:mc+1,cp1);                                           %����������
%title('��Ŀ��FFT����')
for h=1:mc+1
    r_fft1(h,:)=abs(fft(cp1(h,:))); 
end
figure(3),mesh(1:N,1:mc+1,r_fft1);                                         %�������Ž���FFT���
title('��Ŀ��FFT����')
                                                                           %�����
for i=1:78                                                                
for j=1:128
m_hb1(128*(i-1)+j)=r_fft1(j,i);
end
end                                                                        %FFT��Ķ�άת��Ϊһά
[max0,quwei]=max(m_hb1);                                                  %�����ֵ��λ��
for i=(quwei-1):(quwei+1);
y0(i-(quwei-2))=m_hb1(i);
y1(i-(quwei-2))=20*log10(y0(i-(quwei-2)));                                 
end
x1=1:1:3;
xi1=1:1/360:3;
yi1=interp1(x1,y1,xi1,'cubic');                                            %���ڲ庯��������
figure(10);
plot(x1,y1,'o',xi1,yi1);                         
ylabel('���ȣ�dB��');
title('����');

figure(4);
v=0;
for i=0:1:60
    v=v+1;
    fd=2*v*fc/(3e8);              
    mr=repmat(m_delay1,1,N);
    j=1:mc*N;
    y=cos(2*pi*fd/fm*j);
    sr=A1*mr.*y;
    sr_snr=awgn(sr,snr,'measured');
    my=conv(sr_snr,k1);  
 for r=1:N    
    for h=1:mc        
        cp1(h,r)=my((r-1)*mc+h);     
    end
 end
cp11=cp1';
cp11=[cp11,zeros(78,1)];
cp11=cp11';
 for h=1:mc+1
    r_fft1(h,:)=abs(fft(cp11(h,:))); 
 end
mesh(1:N,1:mc+1,r_fft1);
hold on;                                                                   %�������Ž���FFT���  
end
box on;
title('��Ŀ��FFT����')
%--------------------------��������������----------------------------------%

%% ************************˫Ŀ��******************************* %%
n_delay2=fix(tr2*fm);                                                      %�ӳٵ���Ԫ����,tr2Ϊ�״ﲨ��Ŀ��1�ز�����ʱ��fmΪ��Ƶ
m_delay2=zeros(1,mc);                                                      %m_delayΪ�ز��ĵ�����m���У����ɾ���ռ�
m_delay2(1:n_delay2)=m_127(mc-n_delay2+1:mc);                              %ǰ������ԭm���еĺ󼸸�
m_delay2(n_delay2+1:mc)=m_127(1:mc-n_delay2);                              %�󼸸���ԭm���е�ǰ����
mr2=repmat(m_delay2,1,N);                                                  %�����m���У��ӳ�n_delay����Ԫ��������Ŀ�������Ϣ
j2=1:mc*N;                                                                 %�Ա���
sr2=A2*mr2.*cos(2*pi*fd2/fm*j2);                                           %Ŀ��1�Ļز��ź�               
sr2_snr=awgn(sr2,snr,'measured');                                          %�����Ϊsnr,awgnָ���Ը�˹������
sr=sr1+sr2;
sr_snr=sr1_snr+sr2_snr;

%% ---------------------------��ѹ----------------------------- %%
k=fliplr(m_127);                                  
my=conv(sr_snr,k);                                                         %����ѹ������
figure(5),plot(abs(my));                                                   %������ѹ��Ĳ���  
title('˫Ŀ������ѹ����Ĳ���');

%% ---------------------------FFT------------------------------ %%
for r=1:N    
    for h=1:mc         
        cp(h,r)=my((r-1)*mc+h);     
    end
end
cp=cp';
cp=[cp,zeros(78,1)];
cp=cp';
%figure(6),mesh(1:N,1:mc+1,cp);                                            %����������
%title('˫Ŀ��FFT����')

for h=1:mc+1  
    r_fft(h,:)=abs(fft(cp(h,:))); 
end
figure(6),mesh(1:N,1:mc+1,r_fft);                                          %�������Ž���FFT���
title('˫Ŀ��FFT����')

%% -------------------- ���԰���������Ƶ�� ------------------- %%
fdht=[0:500:4000];
zhuban=[0.5*9.845e5,4.824e5,4.69e5,4.471e5,4.172e5,3.751e5,3.409e5,3.2053e5,3.092e5];
%pangban=[8300,9769,1.758e4,2.489e4,3.122e4,3.63e4,4.016e4,4.333e4];       %�˴��������԰�
%rate=zhuban./pangban;
zhuban=20*log10(zhuban);
xx=0:10:4000;
yy=interp1(fdht,zhuban,xx,'cublic');
figure(7),plot(xx,yy,fdht,zhuban,'.');
title('�����������Ƶ�ʵĹ�ϵ');
xlabel('������Ƶ��fd/Hz');
ylabel('�������/dB');

