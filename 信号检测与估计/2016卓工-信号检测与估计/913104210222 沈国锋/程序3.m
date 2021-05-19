%����ѭ�������������������

clc;
clear all;
close all;
tic;
store=ones(1,100);
for xuhao=1:200
    fd1=5000*(xuhao-1);

A1=1;%�ز�ǿ��
d1=000;%����m
snr= 100;%�ز������(�ɱ�)

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
msfull=repmat(ms,1,N);%��127���ȵ�M������������N��

%���²���ռ�ձȷ�������ms1���
y=(1+square((0:2*pi/1270:2*pi*N/10),10))/2;%����ռ�ձȷ�������y
y(219965:end)=[ ];%ɾ������ĵ㣬ʹ���ж���
%������1270�����ڣ�10%ռ�ձȵķ���

%-*1.���ɻز��ź�
i=linspace(0,N*127-1,N*127);
c1=A1*exp(j*(2*pi*fd1/fm*i-pi*400/3*d1));%������Ƶ�ƺ�����
send=msfull.*y;%�����ź�
temp1=c1.*msfull.*y;%���������źŴ���temp1
%clear y;

echo1=zeros(1,N*127);
echo1(1,1+round(0.146667*d1):N*127)=temp1(1,1:(N*127-round(0.146667*d1)));%����ʱ��
echoSingle=awgn(echo1,snr,'measured');%adds white Gaussian noise,�õ���Ŀ��ز�
clear temp1;

%-*2.��ѹ��ʹ��127��m������Ϊƥ�䲨�Σ��õ�ƥ���˲�������ݴ���MF1---
local=fliplr(repmat(ms,1,1));%����
MF1=conv(local,echoSingle);
MF1=MF1(127*1:1:end);%ȥ��ǰ1*127������

store(1,xuhao)=real(abs(MF1(1,1)))/127;%max(real(MF1))/127;
%sound(sin(1:0.3:100));
fprintf('�� %2.0f ��ѭ��\n ',xuhao);
end
p=127;%��ɳ���
t=1/22e6;%���
fd=0:1:1000000;%������Ƶ��
L=abs(sin(pi.*fd*p*t)/p./sin(pi.*fd*t));
figure
%%
plot(fd,L,1:5000:10e5,store,'r.'),legend('��������','ʵ�ʷ�����');
title('��ѹ������ʧ�������Ƶ�ʵĹ�ϵ'),xlabel('������Ƶ��/Hz'),ylabel('��ʧ��');
grid on;

toc;
break
