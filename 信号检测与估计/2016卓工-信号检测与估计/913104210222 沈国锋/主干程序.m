%Ver1.2
%��Ϊ���������ʽ�����������ı��ݰ汾 ��ʵ�鱨���ϵ�������
%------------------------***������־
%4��11�գ������α������������źŲ������õ��˻ز��źţ�����ʱ�Ӻ�Ƶ�ƣ�����ƥ���˲�
%���Լ�-10db�µ����塣 ֮�������������Ų���FFT  x1=x(1:k:end) ���Լ������
%4��20�գ�����������Ϊ���岨��ÿ10��M�������ڷ���һ�����壬m������ʼ���롣
%4��21�գ�����˾��������ţ���������������Ƶ�ʵ����㣬mesh��ͼ
%22�գ������fft��غ����ͽ�Ƶ����ɢ��ģ��ı任��ϵ����FFT���õ��ٶ�ά���������⣺
%���ݲ��������ɲ⵽������ٶ�Ϊ129.9m/s,�������8959m.���ٶȾ��ȣ�1.014m,���뾫��6.81m
%23�� ����˫Ŀ��ز����õ�Ŀ��ʱһ���Ĵ�������ȫ��Ҫ����ɡ�
%26������ʦ�������Ϊ��������������µ���FFT����ٶȶ�Ӧ��ϵ
clc;
clear all;
close all;
tic;

%%--��������Ŀ��Ĳ���
A1=1;%�ز�ǿ��
d1=1520;%����m
v1=60;%�ٶ�m/s
fd1=200/3*v1;%��Ӧ10GHz�µĶ�����Ƶƫ,����ģ�����ɻز�
A2=1;
d2=200;
v2=22;
fd2=200/3*v2;
snr= 10;%�ز������(�ɱ�)

fm=22e6;%��Ƶ
fs=22e6*1270;%������������ftʱ�Ĳ�����
fc=10e9;%��Ƶ
t=10e-3;%��ɻ�����ʱ��
T=1/fm*127;%����
N=round(10e-3/(127*1/22E6)); %����ʱ�䲻����10ms������õ�127����M���е����ش���(N=173)

%--���ɻ����ź�
%----����127��m����
n = 7; % �״�
p = 2^n -1; % ѭ������
ms = idinput(p, 'prbs')';% Gives a p-length pseudorandom sequence
msfull=repmat(ms,1,N);%��127���ȵ�M������������N��
figure
plot(autocorr(msfull,1024),'r');%����M����ѭ������غ���,��󳤶�1024��
title('127-M���е�����غ���'),xlabel('����n'),ylabel('Rx')
%�����Ѿ�������127��M����ms������������N=1732�Σ��洢��msfull

%���²���ռ�ձȷ�������ms1���
y=(1+square((0:2*pi/1270:2*pi*N/10),10))/2;%����ռ�ձȷ�������y
y(219965:end)=[ ];%ɾ������ĵ㣬ʹ���ж���
%������1270�����ڣ�10%ռ�ձȵķ���
% figure
% stairs(y)
% ylim([-2 2])

%������������**��Ŀ�������������������������������������
%-*1.���ɻز��ź�
i=linspace(0,N*127-1,N*127);
c1=A1*exp(j*(2*pi*fd1/fm*i+2*pi*fc*2*d1/3e8));%������Ƶ�ƺ�����
send=msfull.*y;%�����ź�
temp1=c1.*msfull.*y;%����Ƶ�ƺ���źŴ���temp1
%clear y;

echo1=zeros(1,N*127);
echo1(1,1+round(0.146667*d1):N*127)=temp1(1,1:(N*127-round(0.146667*d1)));%����ʱ��
echoSingle=awgn(echo1,snr,'measured');%adds white Gaussian noise,�õ���Ŀ��ز�
clear temp1;

figure;%����ͽ����ź���ͼ
subplot(211);
stairs(send);title('����Ļ����ź�'),xlabel('������');
xlim([0 10000]),ylim([-2 2]);

subplot(212);
stairs(echoSingle);title('�»�Ƶ��Ļز��ź�(ʱ��,Ƶ��,����)'),,xlabel('������');
xlim([0 10000]);

% plot(fftshift(abs(fft(echo))));
% xlim([0 10000])
%-*2.��ѹ��ʹ��127��m������Ϊƥ�䲨�Σ��õ�ƥ���˲�������ݴ���MF1---
local=fliplr(repmat(ms,1,1));%����
MF1=conv(local,echoSingle);
MF1=MF1(127*1:1:end);%ȥ��ǰ1*127������

figure;%������ѹ���ͼ��
subplot(211);
x=linspace( 0,length(MF1)*75/11,length(MF1) );%���ɶ�Ӧ�ľ�������
plot(x,MF1);title('��ѹ���ͼ��'),xlabel('����'),ylabel('��ֵ');
xlim([0 10000])

subplot(212);
%MF1=MF1./(max(max(MF1)));%��һ��
plot(x,20.*log10(MF1) );title('��ѹ���ͼ��(��������)'),xlabel('����'),ylabel('db');
% semilogy(x,MF1);
% ylim([-10 500])
xlim([0 10000])


% figure;%����ѹ���ͼ����fft
%  plot(abs(fft(MF1)));
%  xlim([0 1000])
%-*3.����������---���ݴ���RangeCellA[]��1270*173�ľ���1270�������ţ�173���ֵ����
%RangeCellA=zeros(1270,173);
for i=1:1270
    RangeCellA(: ,i)=MF1(i:1270:1270*170+i);
end
figure;mesh(1:75/11:1270*75/11,1:171,real(RangeCellA)),xlabel('����'),ylabel('�������');
%pause
%-*4.FFT---��ͬһ�����ŵ�������fft���õ��ٶ���-------
NFFT=2^nextpow2(length(RangeCellA(:,1)));
%����Hamming������
W1=0.54+0.46*cos(pi.*linspace(-1,1,171))';%----������
W1=repmat(W1,1,1270);
FFTA=fft(W1.*RangeCellA,NFFT);%�Ӵ����ÿ����FFT,����ΪNFFT=256
figure;
subplot(211)
surfl(1:1:1270,1:NFFT,abs(FFTA)),title('��FFT'),xlabel('���������'),ylabel('FFT����');
shading flat;
%FFTAspeed=FFTA(1:NFFT/2+1,:);
subplot(212)
speed=[259.843/NFFT*(0:1:NFFT/2-1)  259.843/NFFT*(-NFFT/2+1:1:0) ];%FFT��Ķ�Ӧ�ٶ�ά
surfl(1:75/11:1270*75/11,speed,abs(FFTA) );
shading flat;
title('���㵽�ٶ�ά'),xlabel('���� m'),ylabel('�ٶ� m/s');

sound(sin(1:1:300));
disp('��Ŀ��ʱ�Ĵ������,press any key to continue..');
toc;
pause;
%---------------��Ŀ�괦���˽�����---
%-------------**��ʼ˫Ŀ���źŴ���-----
tic
%--*1.���ɵڶ���Ŀ��Ļز�,-----
i=linspace(0,N*127-1,N*127);
c2=A2*exp(j*2*pi*fd2/fm*i+j*2*pi*fc*2*d2/3e8);%������Ƶ�ƺ�����
temp2=c2.*msfull.*y;
clear y;
echo2=zeros(1,N*127);
echo2(1,1+round(0.146667*d2):N*127)=temp2(1,1:(N*127-round(0.146667*d2)));%����ʱ��
echoDouble=awgn(echo2+echo1,snr,'measured');%adds white Gaussian noise,�õ���˫Ŀ��Ļز�������echoDouble
figure;%˫Ŀ��ʱ�ز��ź���ͼ
subplot(211);
stairs(send);title('����Ļ����ź�'),xlabel('������'),ylabel('��ֵ');
xlim([0 10000]),ylim([-2 2]);
subplot(212);
stairs(echoDouble),title('˫Ŀ��Ļز�'),xlabel('������'),ylabel('��ֵ');
xlim([0 10000]);

%-*2.�Իز���ѹ,ƥ���˲�������ݴ���MF2---------
MF2=conv(local,echoDouble);
MF2=MF2(127*1:1:end);%ȥ��ǰ1*127������
clear echoDouble;
clear echoSingle;
figure;%������ѹ���ͼ��
x=linspace( 0,length(MF2)*75/11,length(MF2) );%���ɶ�Ӧ�ľ�������
plot(x,MF2);title('��ѹ���ͼ��'),xlabel('����');
xlim([0 10000]);

%-*3.����������---���ݴ���RangeCellA[]��1270*173�ľ���1270�������ţ�173���ֵ����
RangeCellB=zeros(171,1270);%˫Ŀ������ž���
for i=1:1270
    RangeCellB(: ,i)=MF2(i:1270:1270*170+i);
end
figure;mesh(1:75/11:1270*75/11,1:171,real(RangeCellB) ),title('������������'),xlabel('����'),ylabel('�������');
%pause
%-*4.FFT---��ͬһ�����ŵ�������fft���õ��ٶ���-------
NFFT=2^nextpow2(length(RangeCellB(:,1)));
FFTB=fft(W1.*RangeCellB,NFFT);%��Hamming�����ÿ����FFT,����ΪNFFT=256
figure;
subplot(211)
surfl(1:1:1270,1:NFFT,abs(FFTB)),title('��FFT��'),xlabel('���������'),ylabel('FFT����');
shading flat;
%FFTBspeed=FFTB(1:NFFT/2+1,:);%ȡǰһ��FFT��ֵ|��Ϊ������ʽ����Բ⵽���ٶ�
subplot(212)%���㵽�ٶ�ά
surfl(1:75/11:1270*75/11,speed,abs(FFTB) );
shading flat;
title('���㵽�ٶ�ά'),xlabel('���� m'),ylabel('�ٶ� m/s');
sound(sin(1:1:200));
toc