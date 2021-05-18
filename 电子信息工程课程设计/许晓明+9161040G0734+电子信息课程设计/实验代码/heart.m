clc;
clear;
close all;
N=1024;
fs=300;
Ts=1/fs;
n=0:N-1;
fp=n/N*fs;
[FileName,PathName] = uigetfile('USB.dat','Select the USB.dat file');
f = fullfile(PathName,filesep,FileName);
fid = fopen(f,'r');
data = fscanf(fid,'%x');
fclose(fid);
data = data(1:2:end)*256 + data(2:2:end);%进制转换
data_2=data;
% figure(3)
% plot(data_2);
% grid on;axis tight;
data=data-mean(data);%隔直
dataal=data;
m=max(data);
n=min(data);
data=data/(m-n);%量化
datsgn1 = data;
figure(1)
subplot(2,1,1);
plot(datsgn1);%时域波形
grid on;axis tight;
title('隔直量化后的心电图');
xlabel('采样点');ylabel('电压/mv');
F1=fftshift(fft(datsgn1));
figure(1)
subplot(2,1,2);
plot(abs(F1));
grid on;axis tight;
title('隔直量化后的心电图频域图');
%加滤波器
fp=0.05;fc=100;As=80;Ap=1;Fs=300;
wc=2*pi*fc/Fs;
wp=2*pi*fp/Fs;
wd=wc-wp;
beta=0.1102*(As-8.7);
N=ceil((As-7.95)/2.286/wd);
wn=kaiser(N+1,beta);
ws=(wp+wc)/2/pi;
b=fir1(N,ws,wn);
datsgn2=fftfilt(b,data);
F2=fftshift(fft(datsgn2));
figure(2)
subplot(2,1,1);
plot(datsgn2);
grid on;axis tight;
title('加窗后的心电图');
xlabel('采样点');ylabel('电压/mv');
figure(2)
subplot(2,1,2);
plot(abs(F2));
grid on;axis tight;
title('加窗后的心电图的频域图');
%*********************************计算心率
 [pks,locs] = findpeaks(datsgn2,'MINPEAKDISTANCE',50,'MINPEAKHEIGHT',0.2);
dis=diff(locs);
avrdis=mean(dis);
beat=round(fs/avrdis*60);    
display('此人的心率(bpm)为:')
display(num2str(beat))
if beat>=60&&beat<=100
display('正常人的心率在60-100bpm，因此此人心率正常')
else
    if beat<60
display('此人的心率此人心率过低')
    else
    display('此人的心率此人心率过高')
    end
end