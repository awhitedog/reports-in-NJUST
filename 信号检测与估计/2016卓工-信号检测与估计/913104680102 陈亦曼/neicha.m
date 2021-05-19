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
m_1270=[m_bip zeros(1,1143)];%占空比10%补零
hb=repmat(m_1270,1,N);
pipei=fliplr(m_1270);%矩阵沿垂直轴左右翻转
hbb=conv(pipei,hb);
[maxa,adress]=max(hbb);
for i=1:5
y(i)=20*log10(hbb(i+adress-3));
end
x=1:1:5;
xi=1:1/360:5;
yi=interp1(x,y,xi,'cubic');%内插函数
figure;
plot(x,y,'o',xi,yi);
ylabel('幅度（dB）');
title('时宽内插函数');
