%用于循环计算多普勒敏感曲线

clc;
clear all;
close all;
tic;
store=ones(1,100);
for xuhao=1:200
    fd1=5000*(xuhao-1);

A1=1;%回波强度
d1=000;%距离m
snr= 100;%回波信噪比(可变)

fm=22e6;%码频
fs=22e6*1270;%多普勒余弦作ft时的采样率
fc=10e9;%载频
t=10e-3;%相干积累总时宽
T=1/fm*127;%周期
N=round(10e-3/(127*1/22E6)); %积累时间不大于10ms，计算得到127长度M序列的延拓次数

%--生成基带信号
%----生成127点m序列
n = 7; % 阶次
p = 2^n -1; % 循环周期
ms = idinput(p, 'prbs')';% Gives a p-length pseudorandom sequence
msfull=repmat(ms,1,N);%将127长度的M序列周期延拓N次

%以下产生占空比方波，与ms1点乘
y=(1+square((0:2*pi/1270:2*pi*N/10),10))/2;%产生占空比方波存入y
y(219965:end)=[ ];%删除多余的点，使序列对齐
%产生了1270点周期，10%占空比的方波

%-*1.生成回波信号
i=linspace(0,N*127-1,N*127);
c1=A1*exp(j*(2*pi*fd1/fm*i-pi*400/3*d1));%多普勒频移和相移
send=msfull.*y;%发射信号
temp1=c1.*msfull.*y;%完整发射信号存入temp1
%clear y;

echo1=zeros(1,N*127);
echo1(1,1+round(0.146667*d1):N*127)=temp1(1,1:(N*127-round(0.146667*d1)));%加入时延
echoSingle=awgn(echo1,snr,'measured');%adds white Gaussian noise,得到单目标回波
clear temp1;

%-*2.脉压，使用127点m序列作为匹配波形，得到匹配滤波后的数据存在MF1---
local=fliplr(repmat(ms,1,1));%反褶
MF1=conv(local,echoSingle);
MF1=MF1(127*1:1:end);%去除前1*127点数据

store(1,xuhao)=real(abs(MF1(1,1)))/127;%max(real(MF1))/127;
%sound(sin(1:0.3:100));
fprintf('第 %2.0f 次循环\n ',xuhao);
end
p=127;%相干长度
t=1/22e6;%码宽
fd=0:1:1000000;%多普勒频率
L=abs(sin(pi.*fd*p*t)/p./sin(pi.*fd*t));
figure
%%
plot(fd,L,1:5000:10e5,store,'r.'),legend('理论曲线','实际仿真结果');
title('脉压增益损失与多普勒频率的关系'),xlabel('多普勒频率/Hz'),ylabel('损失比');
grid on;

toc;
break
