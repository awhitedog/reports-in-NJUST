%%%%%%%%没有加延时信息%%%%%%%%%

t=0.01; %相参时间10ms
v=10;   %目标速度10m/s、
c=3e8;  %光速
f0=10000000000;  %载频 10Ghz
fp=5000;      %重复周期 
fd=2*v*f0/c;  %duople频率
fs=10000000;  %采样频率
pha=0;        %初相位
tao=4.5;      %占空比%
n=0:1/fs:2e-4;
tn=0:1/fs:t;
m=50;         %相参时间内的总脉冲数
snr=-10;      %输入信噪比-10dB
N=fs/fp;

%%%%%%%%%产生回波视频信号%%%%%%%%%%%%%%%
spt=(square(2*pi*fp*n,tao)+1)/2;    %矩形包络
sp=repmat(spt,1,m);                 %发射信号
n2=0:1/fs:(100050-1)*1/fs;
Sd=exp(2*j*pi*fd*n2);                %多普勒信息
sp=sp.*Sd;                           %回波
figure;
subplot(211);
plot(real(sp));
title('无躁回波时域波形图');
axis tight;
sp_fft=fft(sp);
subplot(212);
plot(abs(sp_fft));
title('无躁回波频域波形图');

%%%%%%%%%叠加高斯白噪声%%%%%%%%%%
sp_noise=awgn(sp,snr,'measured'); %利用awgn函数产生高斯白噪声
noise=sp_noise-sp;%高斯白噪声
figure;
subplot(211);
plot(real(noise));
title('高斯噪声波形');
subplot(212);
hist(real(noise));
title('高斯噪声直方图');

%%%%%%%%%%冲击响应函数%%%%%%%%%%%%
h=fliplr(spt);%是一个周期的矩形包络的反折函数

%%%%%%%%%%%脉压%%%%%%%%%%%%%%%%
sh=conv(sp,h);  %无躁信号脉压
figure;
subplot(211);
plot(abs(sh));
title('无躁脉压');
sh_noise=conv(sp_noise,h);  %有躁信号脉压
subplot(212);
plot(20*log10(abs(sh_noise)));
title('化为功率单位的有躁脉压');
figure;
plot(20*log10(abs(sh)));

%%%%%%%%计算脉压后信噪比%%%%%%%%
n=abs(sh_noise.^2);
s=abs(sh_noise);
pn1=10*log10(sum(n(:))/(2001*m));  %噪声功率
ps1=10*log10((max(s(:)).^2));      %信号功率   
bd1=ps1-pn1                        %脉压后信噪比

%%%%%%%%%%距离们重排后fft%%%%%%%%%
for r=1:m

    for z=1:2001

        s_hb1(z,r)=sh_noise((r-1)*2001+z); %sh-noise有躁脉压信号

    end 

end 
figure;
mesh(1:m,1:2001,abs(s_hb1)); %脉压三维图

%%%%%%%%%fft%%%%%%%%%%%
for z=1:2001

r_fft(z,:)=abs(fft(s_hb1(z,:))); 

end 
figure;
mesh(1:m,1:2001,r_fft);   %FFT后三维图

%%%%%%%%%%计算FFT后信噪比%%%%%%%

p=(r_fft).^2;
pn2=10*log10(sum(p(:))/(2001*m));
ps2=10*log10((max(r_fft(:)).^2));
bd2=ps2-pn2 

figure;
plot(r_fft); %fft二维图
axis tight;
 



