%%%%%%%%û�м���ʱ��Ϣ%%%%%%%%%

t=0.01; %���ʱ��10ms
v=10;   %Ŀ���ٶ�10m/s��
c=3e8;  %����
f0=10000000000;  %��Ƶ 10Ghz
fp=5000;      %�ظ����� 
fd=2*v*f0/c;  %duopleƵ��
fs=10000000;  %����Ƶ��
pha=0;        %����λ
tao=4.5;      %ռ�ձ�%
n=0:1/fs:2e-4;
tn=0:1/fs:t;
m=50;         %���ʱ���ڵ���������
snr=-10;      %���������-10dB
N=fs/fp;

%%%%%%%%%�����ز���Ƶ�ź�%%%%%%%%%%%%%%%
spt=(square(2*pi*fp*n,tao)+1)/2;    %���ΰ���
sp=repmat(spt,1,m);                 %�����ź�
n2=0:1/fs:(100050-1)*1/fs;
Sd=exp(2*j*pi*fd*n2);                %��������Ϣ
sp=sp.*Sd;                           %�ز�
figure;
subplot(211);
plot(real(sp));
title('����ز�ʱ����ͼ');
axis tight;
sp_fft=fft(sp);
subplot(212);
plot(abs(sp_fft));
title('����ز�Ƶ����ͼ');

%%%%%%%%%���Ӹ�˹������%%%%%%%%%%
sp_noise=awgn(sp,snr,'measured'); %����awgn����������˹������
noise=sp_noise-sp;%��˹������
figure;
subplot(211);
plot(real(noise));
title('��˹��������');
subplot(212);
hist(real(noise));
title('��˹����ֱ��ͼ');

%%%%%%%%%%�����Ӧ����%%%%%%%%%%%%
h=fliplr(spt);%��һ�����ڵľ��ΰ���ķ��ۺ���

%%%%%%%%%%%��ѹ%%%%%%%%%%%%%%%%
sh=conv(sp,h);  %�����ź���ѹ
figure;
subplot(211);
plot(abs(sh));
title('������ѹ');
sh_noise=conv(sp_noise,h);  %�����ź���ѹ
subplot(212);
plot(20*log10(abs(sh_noise)));
title('��Ϊ���ʵ�λ��������ѹ');
figure;
plot(20*log10(abs(sh)));

%%%%%%%%������ѹ�������%%%%%%%%
n=abs(sh_noise.^2);
s=abs(sh_noise);
pn1=10*log10(sum(n(:))/(2001*m));  %��������
ps1=10*log10((max(s(:)).^2));      %�źŹ���   
bd1=ps1-pn1                        %��ѹ�������

%%%%%%%%%%���������ź�fft%%%%%%%%%
for r=1:m

    for z=1:2001

        s_hb1(z,r)=sh_noise((r-1)*2001+z); %sh-noise������ѹ�ź�

    end 

end 
figure;
mesh(1:m,1:2001,abs(s_hb1)); %��ѹ��άͼ

%%%%%%%%%fft%%%%%%%%%%%
for z=1:2001

r_fft(z,:)=abs(fft(s_hb1(z,:))); 

end 
figure;
mesh(1:m,1:2001,r_fft);   %FFT����άͼ

%%%%%%%%%%����FFT�������%%%%%%%

p=(r_fft).^2;
pn2=10*log10(sum(p(:))/(2001*m));
ps2=10*log10((max(r_fft(:)).^2));
bd2=ps2-pn2 

figure;
plot(r_fft); %fft��άͼ
axis tight;
 



