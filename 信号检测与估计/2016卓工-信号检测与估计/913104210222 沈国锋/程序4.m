%ѭ������õ���ѹ���԰���������Ƶ�ʵ�����

clc;
clear all;
close all;
tic;
MSR=ones(1,201);
MainLobe=ones(1,201);
SideLobe=ones(1,201);
for xuhao=1:201
    fd1=865*(xuhao-1);

A1=1;%�ز�ǿ��
d1=000;%����m
snr= 1000;%�ز������(�ɱ�)

fm=22e6;%��Ƶ
fs=22e6*1270;%������������ftʱ�Ĳ�����
fc=10e9;%��Ƶ
t=10e-3;%��ɻ�����ʱ��
T=1/fm*127;%����
N=round(10e-3/(127*1/22E6)); %����ʱ�䲻����10ms������õ�127����M���е����ش���

%--���ɻ����ź�
%----����127��m����
n = 7; % �״�
p = 2^n -1; % ѭ������
ms = idinput(p, 'prbs')';% Gives a p-length pseudorandom sequence
ms1period=[ms zeros(1,1143)];
msfull=repmat(ms1period,1,round(N/10)+1);%��127���ȵ�M������������N��

%���²���ռ�ձȷ�������ms1���
% y=(1+square((0:2*pi/1270:2*pi*N/10),10))/2;%����ռ�ձȷ�������y
msfull(219965:end)=[ ];%ɾ������ĵ㣬ʹ���ж���
%������1270�����ڣ�10%ռ�ձȵķ���

%-*1.���ɻز��ź�
i=linspace(0,N*127-1,N*127);
c1=A1*exp((j*2*pi*fd1/fm*i-pi*400/3*d1));%������Ƶ�ƺ�����
send=msfull;%�����ź�
temp1=c1.*msfull;%���������źŴ���temp1
%clear y;

echo1=zeros(1,N*127);
echo1(1,1+round(0.146667*d1):N*127)=temp1(1,1:(N*127-round(0.146667*d1)));%����ʱ��
echoSingle=awgn(echo1,snr,'measured');%adds white Gaussian noise,�õ���Ŀ��ز�
clear temp1;

%-*2.��ѹ��ʹ��127��m������Ϊƥ�䲨�Σ��õ�ƥ���˲�������ݴ���MF1---
local=fliplr(repmat(ms,1,1));%����
MF1=conv(local,echoSingle);
MF1=MF1(127*1:1:end);%ȥ��ǰ1*127������
MainLobe(xuhao)=abs((MF1(1,1)));
SideLobe(xuhao)=max(abs(MF1(1,2:127)));
fprintf('�� %2.0f ��ѭ��\n ',xuhao);
end

%%
close all
figure
plot(0:865:173000,MainLobe,'b',0:865:173000,SideLobe,'r--'),legend('�����ֵ','�԰��ֵ');
title('�����ֵ���ֵ�԰��ֵ'),xlabel('������Ƶ�� Hz'),ylabel('��ֵ');
grid on
% figure
% plot(0:865:173000,SideLobe)
figure
MSR=20*log10(MainLobe./SideLobe);
plot(0:865:173000,MSR);
title('���԰���������Ƶ�ʵĹ�ϵ'),xlabel('������Ƶ��/Hz'),ylabel('dB');
grid on;

toc;
break
