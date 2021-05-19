clear;
clc;
close all;
%================================��Ŀ�����===============================%?
M = 1;%Ŀ������
d = 5000;%Ŀ�����/m
v = 20;%Ŀ���ٶ�/m/s
A = 100;%Ŀ�����
%================================˫Ŀ�����===============================%?
% M = 2;%Ŀ������
% d = [5000 5000];%Ŀ�����/m
% v = [20 24];%Ŀ���ٶ�/m/s
% A = [100 100];%Ŀ�����
%================================�������=================================%?
SNR = -10;%�����/dB
c = 3e8;%����/m/s
f = 10e9;%�ز�Ƶ��/Hz
fd = 2*v/c*f;%������Ƶƫ/Hz
Fs = 10e6;%����Ƶ��/Hz
width = 5e-6; %����/s
BandWidth = 1/width;%�źŴ���/Hz
TimeWidth = 200e-6;%�ź�ʱ��/s
Time = 6000e-6;%�ź���ʱ��/s
TotalNumber = Time*Fs;%�ܲ�����
PulseNumber = Time/TimeWidth;%������
SampleNumber = TotalNumber/PulseNumber;%�����ڲ�����
t = -Time: (1/Fs) : Time; %ʱ��/s
t0 = 0 : (1/Fs) : TimeWidth-(1/Fs);
sc = c*t0/2;%����/m
t1 = 0 : PulseNumber-1;
vc = t1*Fs/TotalNumber*c/f/2;%�ٶ�/m/s
%?======================�������ֱ������ٶȷֱ���=========================%?
sf = c/2*width;
vf = c/f/(2*PulseNumber*TimeWidth);
fprintf('����ֱ���Ϊ%f��\n',sf);
fprintf('�ٶȷֱ���Ϊ%f��/��\n',vf);
%================================�����ź�=================================%?
smaichong = 0;
smaichong1 = rectpuls(t-2.5e-6, width);%����������
for st0 = 2.5e-6:200e-6:((PulseNumber-1)*200e-6+2.5e-6)
    smaichong = smaichong +rectpuls(t-st0, width);%���������ź�
end
figure(1);
plot(t,smaichong);
grid on  
axis([0,1000e-6,-1.5,1.5]); 
xlabel('t/s');
title('���䲨��')
%================================�ز��ź�=================================%?
huibo = 0;
for i = 1:M
maichong = 0;
for t0 = (2.5e-6+2*d(i)/c):200e-6:((PulseNumber-1)*200e-6+2.5e-6+2*d(i)/c)
    maichong = maichong +A(i)*rectpuls(t-t0, width);%�ز��źţ�����������Ƶ�ƣ�
end
maichong = maichong .* exp(2*pi*fd(i)*t*j);
huibo = huibo+maichong;%�ز��źţ�����������
end
jieshou = awgn(huibo,SNR,'measured');%�ز��źţ���������
figure(2);
subplot(2,1,1);
plot(t,real(huibo));
grid on  
axis([0,1000e-6,-inf,inf]);
xlabel('t/s');
title('�ز�����(��������');
subplot(2,1,2);
plot(t,real(jieshou));
grid on  
axis([0,1000e-6,-inf,inf]);
xlabel('t/s');
title('�ز�����(��������');
%================================ʱ����ѹ=================================%?
coeff=fliplr(smaichong1);%�������巭ת
pc_time0=conv(jieshou,coeff);%pc_time0Ϊ�ز��͵�����ľ��
t1=-2*Time: (1/Fs) : 2*Time;
figure(3);
plot(t1,real(pc_time0));
axis([0,Time,-inf,inf]);
xlabel('t/s');
title('ʱ����ѹ���');
%?================��������š������ź���������==============================%?
for i=1:PulseNumber
pt(1:SampleNumber,i)=pc_time0(2*TotalNumber+(i-1)*SampleNumber+1:2*TotalNumber+i*SampleNumber);
end
pt_R = real(pt);
figure(4)
mesh(1:PulseNumber,sc,pt_R);
xlabel('����������'),ylabel('����/m'),zlabel('����')
title('���������ź���');
%?============================fft����=====================================%?
for i=1:SampleNumber
 pt_fft(i,1:PulseNumber)=fft(pt(i,1:PulseNumber));
end
pt_fft_R = abs(pt_fft);
figure(5)
mesh(vc,sc,20*log(pt_fft_R));
xlabel('�ٶ�m/s'),ylabel('����/m'),zlabel('����/dB')
title('fft����');
%?===========================������ѹ��SNR=================================%?
zaosheng = jieshou-huibo;%��������
Pzaosheng = sum(zaosheng.*zaosheng)/PulseNumber;
ptMax=pt_R(1,1);
maxa = 1; 
maxb = 1;
for a = 1:SampleNumber
    for b = 1:PulseNumber
        if pt_R(a,b)>ptMax
            ptMax = pt_R(a,b);%�����źŷ�ֵ
            maxa = a;
            maxb = b;
        end
    end
end
ptSNR = 10*log((ptMax)^2/Pzaosheng);
fprintf('��ѹ��������Ϊ%fdB\n',ptSNR);
%?==========================������ѹ��ʱ��================================%?
x = maxb-1:maxb+1;
y = [pt_R(maxa,maxb-1),pt_R(maxa,maxb),pt_R(maxa,maxb+1)];
xi = maxb-1:1/360:maxb+1;
yi = interp1(x,y,xi,'spuline');
figure(7)
plot(x/Fs,real(20*log(y)),'o',xi/Fs,real(20*log(yi)));
xlabel('ʱ��/s');
ylabel('����');
title('��ѹ��ʱ����ȡ');
%?===========================����fft��SNR=================================%?
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
dmc = c*(maxa-1)/Fs/2;%Ŀ�����
vmc = (maxb-1)*Fs/TotalNumber*c/f/2;%Ŀ���ٶ�
ptSNR = 10*log((pt_fftMax)^2/Pzaosheng);
fprintf('fft��������Ϊ%fdB\n',ptSNR);
%?===========================����fft��ʱ��================================%?
x = maxb-1:maxb+1;
y = [pt_fft_R(maxa,maxb-1),pt_fft_R(maxa,maxb),pt_fft_R(maxa,maxb+1)];
xi = maxb-1:1/360:maxb+3;
yi = interp1(x,y,xi,'spuline');
figure(8)
plot(x/TotalNumber*Time,real(20*log(y)),'o',xi/TotalNumber*Time,real(20*log(yi)));
xlabel('ʱ��/s');
ylabel('����');
title('FFT��ʱ����ȡ');
%?=========================����Ŀ�������ٶ�==============================%?
fprintf('Ŀ�����Ϊ%f��\n',dmc);
fprintf('Ŀ���ٶ�Ϊ%f��/��\n',vmc);
