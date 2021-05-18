clc;close all;
h=fir1(48,[0.1,0.2],'bandpass');
m=fix(32768/max(h));
figure(1)
freqz(h)

Am=round(h*m);
max(Am)
figure(2)
freqz(Am)

f=[100 ,200 ,300 ,400 ,500 ,600 ,700 ,800 ,900 ,1000 ,1100 ,1200 ,1300 ,1400 ,1500 ,1600 ,1700 ,1800 ,1900 ,2000 ,2100 ,2200 ,2300 ,2400 ,2500 ,2600 ,2700 ,2800];
A=[1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1]*10;
Fs = 20e3; %sampling rate
Ts = 1/Fs; %sampling time interval
t = 0:Ts:1-Ts; %sampling period
n = length(t); %number of samples
y=zeros(1,n);
for i=1:1:size(f,2)
    for j=1:1:n
    y(j)=A(i)*sin(2*pi*f(i)*t(j))1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1+y(j);
    end
end
%y = 2*sin(2*pi*fo*t); %the sine curve

figure(3)
subplot(2,1,1)
plot(t,y)
title(' ±”Ú≤®–Œ')

N=length(y);
k=0:1:N-1;
T=N/Fs;
frequencyRange=k/T;
YfreqDomain=fft(y)/N;
cutOff = ceil(N/2);
YfreqDomain=YfreqDomain(1:cutOff);
frequencyRange = frequencyRange(1:cutOff);
figure(3)
 subplot(2,1,2)
plot(frequencyRange,abs(YfreqDomain),'LineWidth',1);
title('∆µ”Ú≤®–Œ')
axis([0,3000,0,10])
 fir=zeros(1,size(y,2)-49);
for i=1:1:49
    for j=1:1:(size(y,2)-49)
    fir(j)=fir(j)+y(j+50-i)*Am(i);
    end
end
figure(4)
subplot(2,1,1)
plot(t(1:size(fir,2)),fir)
title(' ±”Ú≤®–Œ')
YfreqDomain=fft(fir)/N;
YfreqDomain=YfreqDomain(1:cutOff);
figure(4)
subplot(2,1,2)
plot(frequencyRange,abs(YfreqDomain),'LineWidth',1);
title('∆µ”Ú≤®–Œ')
axis([0,3000,0,inf])