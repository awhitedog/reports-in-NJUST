clc
close all
a=textread('C:\Users\��\Desktop\�״��ۺ�\��LFM_0.6us_20MHz.txt','%s')';
b=hex2dec(a)';
figure
subplot(221)
plot(b)
f=fft(b);
subplot(222)
plot(f)