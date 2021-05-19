clear all;
clc;
close all;
%=============================条件==================================
fm=2e6;%码频
fc=10e9;%载频
c=3e8;%光速
t=10e-3;%相干积累总时宽
T=1/fm*1270;%相位编码周期
N=15;%周期重复次数(t/T)
snr=-10;%目标回波输入信噪比（-35~10dB）
d1=8000;
d2=8000;%目标距离(0~10000m)
v1=8;
v2=6;%目标速度（0~1000m/s）
A1=1;
A2=1;%目标幅度（1~100）
m=1270;%一个周期内的采样点个数
t1=2*d1/(3e8);
t2=2*d2/(3e8);%延时
n1=round(t1/(5e-7));
n2=round(t2/(5e-7));%延时补零个数
%==============================m序列产生======================
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
clear j;
m_bip=2*mseqmatrix-1;
m_1270=[m_bip zeros(1,1143)];
hb=repmat(m_1270,1,N);
%--------------------加延时和多普勒的回波------------------------
hb1=[zeros(1,n1) hb(1:1270*N-n1)]*A1;
hb2=[zeros(1,n2) hb(1:1270*N-n2)]*A2;
fd1=2*v1/(c/fc);
fd2=2*v2/(c/fc);
duopule1=exp(j*2*pi.*(1:1:1270*N)*fd1/fm);
duopule2=exp(j*2*pi.*(1:1:1270*N)*fd2/fm);
hb21=hb1.*duopule1;
hb22=hb2.*duopule2;
hb23=hb21+hb22;
hb31=awgn(hb23,snr,'measured');
%---------------------------脉压------------------------------
pipei=fliplr(m_1270);
hbb2=conv(pipei,hb31);
%--------------------------距离门重排---------------------------
for r=1:N
for h=1:m
s_hb2(h,r)=hbb2((r-1)*m+h);
end
end
%---------------------------------
for h=1:m
r_fft(h,:)=abs(fft(s_hb2(h,:)));
end
figure;mesh(1:N,linspace(0,95250,1270),real(r_fft));
%figure;mesh(1:N,1:1270,real(r_fft));
title('FFT后输出图形');
xlabel('x/距离门序数');ylabel('y/目标距离');zlabel('z/目标幅度');