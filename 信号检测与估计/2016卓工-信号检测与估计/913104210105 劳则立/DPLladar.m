clear;
clc;
close all;
%================================单目标参数===============================%?
M = 1;%目标数量
d = 5000;%目标距离/m
v = 20;%目标速度/m/s
A = 100;%目标幅度
%================================双目标参数===============================%?
% M = 2;%目标数量
% d = [5000 5000];%目标距离/m
% v = [20 24];%目标速度/m/s
% A = [100 100];%目标幅度
%================================其余参数=================================%?
SNR = -10;%信噪比/dB
c = 3e8;%光速/m/s
f = 10e9;%载波频率/Hz
fd = 2*v/c*f;%多普勒频偏/Hz
Fs = 10e6;%采样频率/Hz
width = 5e-6; %脉宽/s
BandWidth = 1/width;%信号带宽/Hz
TimeWidth = 200e-6;%信号时宽/s
Time = 6000e-6;%信号总时长/s
TotalNumber = Time*Fs;%总采样数
PulseNumber = Time/TimeWidth;%脉冲数
SampleNumber = TotalNumber/PulseNumber;%单周期采样数
t = -Time: (1/Fs) : Time; %时间/s
t0 = 0 : (1/Fs) : TimeWidth-(1/Fs);
sc = c*t0/2;%距离/m
t1 = 0 : PulseNumber-1;
vc = t1*Fs/TotalNumber*c/f/2;%速度/m/s
%?======================计算距离分辨力和速度分辨力=========================%?
sf = c/2*width;
vf = c/f/(2*PulseNumber*TimeWidth);
fprintf('距离分辨力为%f米\n',sf);
fprintf('速度分辨力为%f米/秒\n',vf);
%================================发射信号=================================%?
smaichong = 0;
smaichong1 = rectpuls(t-2.5e-6, width);%产生单脉冲
for st0 = 2.5e-6:200e-6:((PulseNumber-1)*200e-6+2.5e-6)
    smaichong = smaichong +rectpuls(t-st0, width);%产生发射信号
end
figure(1);
plot(t,smaichong);
grid on  
axis([0,1000e-6,-1.5,1.5]); 
xlabel('t/s');
title('发射波形')
%================================回波信号=================================%?
huibo = 0;
for i = 1:M
maichong = 0;
for t0 = (2.5e-6+2*d(i)/c):200e-6:((PulseNumber-1)*200e-6+2.5e-6+2*d(i)/c)
    maichong = maichong +A(i)*rectpuls(t-t0, width);%回波信号（不带多普勒频移）
end
maichong = maichong .* exp(2*pi*fd(i)*t*j);
huibo = huibo+maichong;%回波信号（不加噪声）
end
jieshou = awgn(huibo,SNR,'measured');%回波信号（加噪声）
figure(2);
subplot(2,1,1);
plot(t,real(huibo));
grid on  
axis([0,1000e-6,-inf,inf]);
xlabel('t/s');
title('回波波形(无噪声）');
subplot(2,1,2);
plot(t,real(jieshou));
grid on  
axis([0,1000e-6,-inf,inf]);
xlabel('t/s');
title('回波波形(含噪声）');
%================================时域脉压=================================%?
coeff=fliplr(smaichong1);%将单脉冲翻转
pc_time0=conv(jieshou,coeff);%pc_time0为回波和单脉冲的卷积
t1=-2*Time: (1/Fs) : 2*Time;
figure(3);
plot(t1,real(pc_time0));
axis([0,Time,-inf,inf]);
xlabel('t/s');
title('时域脉压结果');
%?================按照脉冲号、距离门号重排数据==============================%?
for i=1:PulseNumber
pt(1:SampleNumber,i)=pc_time0(2*TotalNumber+(i-1)*SampleNumber+1:2*TotalNumber+i*SampleNumber);
end
pt_R = real(pt);
figure(4)
mesh(1:PulseNumber,sc,pt_R);
xlabel('距离门序数'),ylabel('距离/m'),zlabel('幅度')
title('距离门重排后波形');
%?============================fft数据=====================================%?
for i=1:SampleNumber
 pt_fft(i,1:PulseNumber)=fft(pt(i,1:PulseNumber));
end
pt_fft_R = abs(pt_fft);
figure(5)
mesh(vc,sc,20*log(pt_fft_R));
xlabel('速度m/s'),ylabel('距离/m'),zlabel('幅度/dB')
title('fft波形');
%?===========================计算脉压后SNR=================================%?
zaosheng = jieshou-huibo;%计算噪声
Pzaosheng = sum(zaosheng.*zaosheng)/PulseNumber;
ptMax=pt_R(1,1);
maxa = 1; 
maxb = 1;
for a = 1:SampleNumber
    for b = 1:PulseNumber
        if pt_R(a,b)>ptMax
            ptMax = pt_R(a,b);%计算信号峰值
            maxa = a;
            maxb = b;
        end
    end
end
ptSNR = 10*log((ptMax)^2/Pzaosheng);
fprintf('脉压后的信噪比为%fdB\n',ptSNR);
%?==========================计算脉压后时宽================================%?
x = maxb-1:maxb+1;
y = [pt_R(maxa,maxb-1),pt_R(maxa,maxb),pt_R(maxa,maxb+1)];
xi = maxb-1:1/360:maxb+1;
yi = interp1(x,y,xi,'spuline');
figure(7)
plot(x/Fs,real(20*log(y)),'o',xi/Fs,real(20*log(yi)));
xlabel('时间/s');
ylabel('幅度');
title('脉压后时宽求取');
%?===========================计算fft后SNR=================================%?
pt_fftMax=pt_fft_R(1,1);
maxa = 1; 
maxb = 1;
for a = 1:SampleNumber
    for b = 1:PulseNumber
        if pt_fft_R(a,b)>pt_fftMax
            pt_fftMax = pt_fft_R(a,b);
            maxa = a;
            maxb = b;
        end
    end
end
dmc = c*(maxa-1)/Fs/2;%目标距离
vmc = (maxb-1)*Fs/TotalNumber*c/f/2;%目标速度
ptSNR = 10*log((pt_fftMax)^2/Pzaosheng);
fprintf('fft后的信噪比为%fdB\n',ptSNR);
%?===========================计算fft后时宽================================%?
x = maxb-1:maxb+1;
y = [pt_fft_R(maxa,maxb-1),pt_fft_R(maxa,maxb),pt_fft_R(maxa,maxb+1)];
xi = maxb-1:1/360:maxb+3;
yi = interp1(x,y,xi,'spuline');
figure(8)
plot(x/TotalNumber*Time,real(20*log(y)),'o',xi/TotalNumber*Time,real(20*log(yi)));
xlabel('时间/s');
ylabel('幅度');
title('FFT后时宽求取');
%?=========================计算目标距离和速度==============================%?
fprintf('目标距离为%f米\n',dmc);
fprintf('目标速度为%f米/秒\n',vmc);
