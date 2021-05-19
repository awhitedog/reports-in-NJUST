clear all;
clc;
%========================条件========================
fm=2e6;%码频
fc=10e9;%载频
c=3e8;%光速
t=10e-3;%相干积累总时宽
T=1/fm*1270;%相位编码周期
N=15;%周期重复次数(t/T)
snr=5;%目标回波输入信噪比（-35~10dB）
d=1000;%目标距离(0~10000m)
v=2;%目标速度（0~1000m/s）
A=1;%目标幅度（1~100）
m=1270;%一个周期内的采样点个数
t1=2*d/c;%延时
n1=fix(t1/5e-7);%延时补零个数
%========================m序列产生========================
connection=[1 0 0 0 0 0 1];
n=length(connection);
reg=[1 0 1 0 1 0 1 ];
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
%=======================单目标======================
pipei=fliplr(m_bip);%矩阵沿垂直轴左右翻转
hbb=conv(pipei,m_bip);
m_1270=[m_bip zeros(1,1143)];%占空比10%补零
hb=repmat(m_1270,1,N);
clear j;
%---------------------回波--------------------------------------
hb=[zeros(1,n1) hb(1:1270*N-n1)]*A;%加延时
fd=2*v/(c/fc);
duopule=exp(j*2*pi.*(1:1:1270*N)*fd/fm);
hb1=hb.*duopule;%加多普勒
hb2=awgn(hb1,snr,'measured');%加噪声
% subplot(3,1,1);plot(real(hb));
% subplot(3,1,2);plot(real(hb1));
% subplot(3,1,3);plot(real(hb2));title('受多普勒频率调制的回波');
figure;plot(real(hb2));title('受多普勒频率调制的回波');
%xlabel('t/\mus'),ylabel('hb2(t)')
%---------------------脉压-------------------------------------
pipei=fliplr(m_1270);
hbb1=conv(pipei,hb1);
% m_hb1=abs(hbb1);
% m_hb=abs(hbb1)/max(m_hb1);
% m_hb=10*log10(m_hb);
% figure;plot(m_hb);
hbb2=hbb1(1:2000);
figure;plot(real(hbb2));
title('脉压后一周期内的输出图形');
axis([1250 1300 -20 140]);grid on;
set(gca,'Ytick',[67.5,127],'Xtick',1270);
%---------------------脉压主瓣高度与多普勒的曲线------------------------%
fd1=0:1000:14000;h=1:1:15;
for i=1:15
duopule1=exp(j*2*pi.*(1:1:1270)*fd1(i)/fm);
hb3=m_1270.*duopule1;
pipei=fliplr(m_1270);
hbb3=conv(pipei,hb3);
h(i)=max(10*log10(abs(hbb3)));
%h(i)=max(abs(hbb3));
end
figure;plot(fd1*1e-3,h);
title('脉压主瓣高度与多普勒的曲线');
xlabel('多普勒频率/KHz');ylabel('脉压主瓣高度/dB');
grid on;
set(gca,'Ytick',[17.1,21.04]);
hbb4=conv(pipei,hb2);
%--------距离门重排---------------%
for r=1:N
for h=1:m
s_hb2(h,r)=hbb4((r-1)*m+h);
end
end
figure;mesh(1:N,1:m,real(s_hb2));
%figure;mesh(1:N,linspace(0,95250,1270),real(s_hb2));
title('脉压后输出图形');
xlabel('x/距离门序数');ylabel('y/目标距离');zlabel('z/目标幅度');
%---------------------------------
for h=1:m
r_fft2(h,:)=abs(fft(s_hb2(h,:)));
end
%figure;mesh(1:N,linspace(0,95250,1270),10*log10(real(r_fft2)));
figure;mesh(1:N,1:1270,real(r_fft2));
title('FFT后输出图形');
xlabel('x/目标速度');ylabel('y/目标距离');zlabel('z/目标幅度');
%-----------FFT的时宽和带宽
%求时宽
for i=1:m
for j=1:N
m_hb1(N*(i-1)+j)=r_fft2(i,j);
end
end           %把FFT后的矩阵转换为一维数组
[max0,adress]=max(m_hb1);%取出最大值的位置
for i=(adress-2):(adress+2);
y0(i-(adress-3))=m_hb1(i);
y(i-(adress-3))=20*log10(y0(i-(adress-3)));
end
x=1:1:5;
xi=1:1/360:5;
yi=interp1(x,y,xi,'cubic');%内插函数
figure;
plot(x,y,'o',xi,yi);
ylabel('幅度（dB）');
title('时宽内插函数');
%求带宽
for i=1:N
for j=1:m
m_hb1(m*(i-1)+j)=r_fft2(j,i);
end
end           %把FFT后的矩阵转换为一维数组
[max0,adress]=max(m_hb1);%取出最大值的位置
for i=(adress-1):(adress+1);
y0(i-(adress-2))=m_hb1(i);
y1(i-(adress-2))=20*log10(y0(i-(adress-2)));
end
x1=1:1:3;
xi1=1:1/360:3;
yi1=interp1(x1,y1,xi1,'cubic');%内插函数
figure;
plot(x1,y1,'o',xi1,yi1);
ylabel('幅度（dB）');
title('带宽内插函数');