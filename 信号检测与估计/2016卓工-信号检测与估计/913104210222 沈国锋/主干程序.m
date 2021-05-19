%Ver1.2
%改为复数表达形式，功能正常的备份版本 ，实验报告上的主程序
%------------------------***开发日志
%4月11日，完成了伪随机连续波的信号产生；得到了回波信号（具有时延和频移），作匹配滤波
%可以见-10db下的主峰。 之后工作：距离重排并作FFT  x1=x(1:k:end) 可以间隔采样
%4月20日，将连续波改为脉冲波，每10个M序列周期发送一个脉冲，m序列起始对齐。
%4月21日，完成了距离门重排，抽样产生多普勒频率的样点，mesh作图
%22日，理解了fft相关函数和角频率离散到模拟的变换关系。作FFT，得到速度维。存在问题：
%根据采样定理，可测到的最大速度为129.9m/s,距离最大8959m.→速度精度：1.014m,距离精度6.81m
%23日 产生双目标回波，用单目标时一样的处理方法。全部要求完成。
%26日与老师交流后改为复数表达数，重新调整FFT后的速度对应关系
clc;
clear all;
close all;
tic;

%%--设置两个目标的参数
A1=1;%回波强度
d1=1520;%距离m
v1=60;%速度m/s
fd1=200/3*v1;%对应10GHz下的多普勒频偏,用于模拟生成回波
A2=1;
d2=200;
v2=22;
fd2=200/3*v2;
snr= 10;%回波信噪比(可变)

fm=22e6;%码频
fs=22e6*1270;%多普勒余弦作ft时的采样率
fc=10e9;%载频
t=10e-3;%相干积累总时宽
T=1/fm*127;%周期
N=round(10e-3/(127*1/22E6)); %积累时间不大于10ms，计算得到127长度M序列的延拓次数(N=173)

%--生成基带信号
%----生成127点m序列
n = 7; % 阶次
p = 2^n -1; % 循环周期
ms = idinput(p, 'prbs')';% Gives a p-length pseudorandom sequence
msfull=repmat(ms,1,N);%将127长度的M序列周期延拓N次
figure
plot(autocorr(msfull,1024),'r');%●作M序列循环自相关函数,最大长度1024点
title('127-M序列的自相关函数'),xlabel('样点n'),ylabel('Rx')
%至此已经产生了127点M序列ms，并周期延拓N=1732次，存储在msfull

%以下产生占空比方波，与ms1点乘
y=(1+square((0:2*pi/1270:2*pi*N/10),10))/2;%产生占空比方波存入y
y(219965:end)=[ ];%删除多余的点，使序列对齐
%产生了1270点周期，10%占空比的方波
% figure
% stairs(y)
% ylim([-2 2])

%——————**单目标情况————————————————
%-*1.生成回波信号
i=linspace(0,N*127-1,N*127);
c1=A1*exp(j*(2*pi*fd1/fm*i+2*pi*fc*2*d1/3e8));%多普勒频移和相移
send=msfull.*y;%发射信号
temp1=c1.*msfull.*y;%加上频移后的信号存入temp1
%clear y;

echo1=zeros(1,N*127);
echo1(1,1+round(0.146667*d1):N*127)=temp1(1,1:(N*127-round(0.146667*d1)));%加入时延
echoSingle=awgn(echo1,snr,'measured');%adds white Gaussian noise,得到单目标回波
clear temp1;

figure;%发射和接收信号作图
subplot(211);
stairs(send);title('发射的基带信号'),xlabel('样点数');
xlim([0 10000]),ylim([-2 2]);

subplot(212);
stairs(echoSingle);title('下混频后的回波信号(时移,频移,噪声)'),,xlabel('样点数');
xlim([0 10000]);

% plot(fftshift(abs(fft(echo))));
% xlim([0 10000])
%-*2.脉压，使用127点m序列作为匹配波形，得到匹配滤波后的数据存在MF1---
local=fliplr(repmat(ms,1,1));%反褶
MF1=conv(local,echoSingle);
MF1=MF1(127*1:1:end);%去除前1*127点数据

figure;%●作脉压后的图像
subplot(211);
x=linspace( 0,length(MF1)*75/11,length(MF1) );%生成对应的距离坐标
plot(x,MF1);title('脉压后的图像'),xlabel('距离'),ylabel('幅值');
xlim([0 10000])

subplot(212);
%MF1=MF1./(max(max(MF1)));%归一化
plot(x,20.*log10(MF1) );title('脉压后的图像(对数坐标)'),xlabel('距离'),ylabel('db');
% semilogy(x,MF1);
% ylim([-10 500])
xlim([0 10000])


% figure;%对脉压后的图像作fft
%  plot(abs(fft(MF1)));
%  xlim([0 1000])
%-*3.距离门重排---数据存入RangeCellA[]，1270*173的矩阵，1270个距离门，173点幅值数据
%RangeCellA=zeros(1270,173);
for i=1:1270
    RangeCellA(: ,i)=MF1(i:1270:1270*170+i);
end
figure;mesh(1:75/11:1270*75/11,1:171,real(RangeCellA)),xlabel('距离'),ylabel('样点序号');
%pause
%-*4.FFT---对同一距离门的数据作fft，得到速度量-------
NFFT=2^nextpow2(length(RangeCellA(:,1)));
%生成Hamming窗函数
W1=0.54+0.46*cos(pi.*linspace(-1,1,171))';%----海明窗
W1=repmat(W1,1,1270);
FFTA=fft(W1.*RangeCellA,NFFT);%加窗后对每列作FFT,点数为NFFT=256
figure;
subplot(211)
surfl(1:1:1270,1:NFFT,abs(FFTA)),title('作FFT'),xlabel('距离门序号'),ylabel('FFT样点');
shading flat;
%FFTAspeed=FFTA(1:NFFT/2+1,:);
subplot(212)
speed=[259.843/NFFT*(0:1:NFFT/2-1)  259.843/NFFT*(-NFFT/2+1:1:0) ];%FFT后的对应速度维
surfl(1:75/11:1270*75/11,speed,abs(FFTA) );
shading flat;
title('换算到速度维'),xlabel('距离 m'),ylabel('速度 m/s');

sound(sin(1:1:300));
disp('单目标时的处理完成,press any key to continue..');
toc;
pause;
%---------------单目标处理到此结束。---
%-------------**开始双目标信号处理-----
tic
%--*1.生成第二个目标的回波,-----
i=linspace(0,N*127-1,N*127);
c2=A2*exp(j*2*pi*fd2/fm*i+j*2*pi*fc*2*d2/3e8);%多普勒频移和相移
temp2=c2.*msfull.*y;
clear y;
echo2=zeros(1,N*127);
echo2(1,1+round(0.146667*d2):N*127)=temp2(1,1:(N*127-round(0.146667*d2)));%加入时延
echoDouble=awgn(echo2+echo1,snr,'measured');%adds white Gaussian noise,得到了双目标的回波，存入echoDouble
figure;%双目标时回波信号作图
subplot(211);
stairs(send);title('发射的基带信号'),xlabel('样点数'),ylabel('幅值');
xlim([0 10000]),ylim([-2 2]);
subplot(212);
stairs(echoDouble),title('双目标的回波'),xlabel('样点数'),ylabel('幅值');
xlim([0 10000]);

%-*2.对回波脉压,匹配滤波后的数据存入MF2---------
MF2=conv(local,echoDouble);
MF2=MF2(127*1:1:end);%去除前1*127点数据
clear echoDouble;
clear echoSingle;
figure;%●作脉压后的图像
x=linspace( 0,length(MF2)*75/11,length(MF2) );%生成对应的距离坐标
plot(x,MF2);title('脉压后的图像'),xlabel('距离');
xlim([0 10000]);

%-*3.距离门重排---数据存入RangeCellA[]，1270*173的矩阵，1270个距离门，173点幅值数据
RangeCellB=zeros(171,1270);%双目标距离门矩阵
for i=1:1270
    RangeCellB(: ,i)=MF2(i:1270:1270*170+i);
end
figure;mesh(1:75/11:1270*75/11,1:171,real(RangeCellB) ),title('按距离门排列'),xlabel('距离'),ylabel('样点序号');
%pause
%-*4.FFT---对同一距离门的数据作fft，得到速度量-------
NFFT=2^nextpow2(length(RangeCellB(:,1)));
FFTB=fft(W1.*RangeCellB,NFFT);%加Hamming窗后对每列作FFT,点数为NFFT=256
figure;
subplot(211)
surfl(1:1:1270,1:NFFT,abs(FFTB)),title('作FFT后'),xlabel('距离门序号'),ylabel('FFT样点');
shading flat;
%FFTBspeed=FFTB(1:NFFT/2+1,:);%取前一半FFT的值|改为复数形式后可以测到负速度
subplot(212)%换算到速度维
surfl(1:75/11:1270*75/11,speed,abs(FFTB) );
shading flat;
title('换算到速度维'),xlabel('距离 m'),ylabel('速度 m/s');
sound(sin(1:1:200));
toc