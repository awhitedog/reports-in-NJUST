clc;
clear;
close all;
N=1024;
fs=300;
%hz
Ts=1/fs;
n=0:N-1;
fp=n/N*fs;
[FileName,PathName] = uigetfile('USB.dat','Select the USB.dat file');
f = fullfile(PathName,filesep,FileName);
fid = fopen(f,'r');
data = fscanf(fid,'%x');
fclose(fid);
data = data(1:2:end)*256 + data(2:2:end);%����ת��
data_2=data;
figure(1)
plot(data_2);
grid on;axis([0,300,-inf,inf]);
%axis tight;
%************��ֵ�˲�
data_3=data;
for i=1+2:1:1024-2
    sum=data(i)+data(i-1)+data(i+1)+data(i-2)+data(i+2);
    data_3(i)=sum/5;
end
figure(2)
plot(data_3);
grid on;axis([0,300,-inf,inf]);
%axis tight;