
clear all;
clc;
%================================条件==================================
fm=2e6;%码频
fc=10e9;%载频
c=3e8;%光速
t=10e-3;%相干积累总时宽
T=1/fm*1270;%相位编码周期
N=15;%周期重复次数(t/T)
snr0=10;%目标回波输入信噪比（-35~10dB）
d=1000;%目标距离(0~10000m)
v=0;%目标速度（0~1000m/s）
A=1;%目标幅度（1~100）
m=1270;%一个周期内的采样点个数
t1=2*d/c;%延时
n1=fix(t1/5e-7);%延时补零个数
%==============================m序列产生=================================
connection=[1 0 0 0 0 0 1];
n=length(connection);
reg=[0 0 0 0 0 0 1 ];
mseqmatrix(1)=reg(n);
for i=2:127 
  newreg(1)=mod(sum(connection.*reg),2);
for j=2:n
  newreg(j)=reg(j-1);
end
reg=newreg;
mseqmatrix(i)=reg(n);
end
m_bip=2*mseqmatrix-1;%双值电平
%=============================单目标====================================
m_1270=[m_bip zeros(1,1143)];%占空比10%补零
snr=snr0-10;
hb=repmat(m_1270,1,N);
clear j;
%---------------------------回波---------------------------------------%
hb=[zeros(1,n1) hb(1:1270*N-n1)]*A;%加延时
fd=2*v/(c/fc);
duopule=exp(j*2*pi.*(1:1:1270*N)*fd/fm);
hb1=hb.*duopule;%加多普勒
hb2=awgn(hb1,snr,'measured');%加噪声
%------------------------脉压后的SNR计算--------------------------------%
pipei=fliplr(m_1270);%矩阵沿垂直轴左右翻转
hbb1=conv(pipei,hb1);%无噪声
hbb2=conv(pipei,hb2);%有噪声
hbb3=hbb2-hbb1;
%--------距离门重排---------------%
for r=1:N
for h=1:m
s_hb1(h,r)=hbb1((r-1)*m+h);
s_hb2(h,r)=hbb2((r-1)*m+h);
s_hb3(h,r)=hbb3((r-1)*m+h);
end
end
pp=10*log10(max(max(abs(real(s_hb1))))*max(max(abs(real(s_hb1)))));
pn=s_hb3.*s_hb3;
pn=sum(abs(real(pn(:))))/1270/N;
pn=10*log10(pn);
snr1=pp-pn;
snr1;
%---------------------------------
for h=1:m
r_fft1(h,:)=abs(fft(s_hb1(h,:)));   
r_fft3(h,:)=abs(fft(s_hb3(h,:)));
end
pp1=10*log10(max(max(r_fft1))*max(max(r_fft1)));
pn1=r_fft3.*r_fft3;
pn1=sum(pn1(:))/1270/N;
pn1=10*log10(pn1);
snr2=pp1-pn1;
snr2;

