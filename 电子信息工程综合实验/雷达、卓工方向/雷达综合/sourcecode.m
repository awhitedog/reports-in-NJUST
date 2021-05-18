clc
close all
a=textread('C:\Users\º£\Desktop\À×´ï×ÛºÏ\ÇüLFM_0.6us_20MHz.txt','%s')';
b=hex2dec(a)';
figure
subplot(221)
plot(b)
f=fft(b);
subplot(222)
plot(f)