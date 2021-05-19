close all;
clear all;
clc;
y=0;
T=2e-4;                          %ʱ��
B=30e6;                           %����
K=B/T;                           %��Ƶб��
Fs=8*B;Ts=1/Fs;  
N=T/Ts+1;                        %��������
t=0:Ts:T
NUM=1;                          %��ɻ���������
St=exp(j*pi*K*t.^2);             %�����ź�
%%__________________����غ���___________________
[a,b]=xcorr(St);
Z=abs(a);
figure(1)
plot(Z);
Z=Z/max(Z);                      %��һ��
Z=20*log10(Z);                   %���ɷֱ�
figure(2)        
%%__________�Ŵ�_______
 N0=6*Fs/B;
t2=-N0*Ts:Ts:N0*Ts;
t2=B*t2;
plot(t2,Z(N-N0:N+N0) );
axis([-inf,inf,-30,inf]);grid on;
set(gca,'Ytick',[-13.4,-4,0],'Xtick',[-3,-2,-1,-0.5,0,0.5,1,2,3]);
xlabel('ʱ��*B');
ylabel('��ֵ,dB');
title('�Ŵ��������');
%%_____________________����__________________________
C=3e8;               %����
R=0 ;     %����
V=0  ;        %�ٶ�          
f0=10e9;             %��Ƶ 
lambda=C/f0;         %����
t0=floor(2*R*Fs/C)+1     %��ʱ�ĵ���
Sr=repmat(St,1,NUM);        %��ɻ���
sr=[Sr(NUM*N-t0+1:NUM*N) Sr(1:NUM*N-t0)]     %��ʱ   
fd=2*V/lambda ;                 %������Ƶ��
t=0:Ts:(N*NUM-1)*Ts;
Sd=exp(2*j*pi*fd*t);            %�����������ź�
SR=sr.*Sd;                      %�ز��ź�
h=fliplr(St) ;            %����ƥ���˲���
pipei=conv(conj(h),SR);    %�Իز�����ƥ���˲�
figure(3)
pipei_db=10*log10(abs(pipei.^2));
plot(pipei_db);
title('��ѹ/db');
axis([4780,4850,50,75]);grid on;
set(gca,'Ytick',[69.62,73.62],'Xtick',[4798,4806]);%%��ѹ������Ϊ0���ٶ�Ϊ0,8������Ƶ�ʣ�num=1
