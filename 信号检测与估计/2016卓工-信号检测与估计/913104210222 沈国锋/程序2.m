%��������ѹ������ʧ�������Ƶ�ʵ����ߣ�ͳ����randn��wgn��awgn������������������
clear all
close all
y=0.5+0.5*square(2*pi/500*(1:1:5000),10);
plot(y)
yy=awgn(y,0);
figure
plot(yy)
fprintf('%f',sum(yy(1600:1800).^2)/200)
pause;

%�������۱��ʽ������ѹ������ʧ�������Ƶ�ʵ�����
clear all
close all
p=127;%��ɳ���
t=1/22e6;%���
fd=0:1:1000000;%������Ƶ��
L=abs(sin(pi.*fd*p*t)/p./sin(pi.*fd*t));
figure
subplot(211);
plot(fd,L);
title('��ѹ������ʧ�������Ƶ�ʵĹ�ϵ'),xlabel('������Ƶ��/Hz'),ylabel('��ʧ��');

grid on;
vd=fd./(200/3);
subplot(212);
plot(vd,L);
title('��ѹ������ʧ��Ŀ���ٶȵĹ�ϵ'),xlabel('Ŀ�꾶���ٶ� m/s'),ylabel('��ʧ��');
grid on;

%��֤randm/wgn/awgn�����Ĺ���
close all
clear all
x=ones(1,1000);
y1=randn(1,1000);
y2=wgn(1,1000,0);
y3=awgn(x,5);
y11=xcorr(y1,'coeff');
y11(1:999)=[];
y22=xcorr(y2,'coeff');
y22(1:999)=[];
y33=xcorr(y3-1,'coeff');
y33(1:999)=[];
figure;%������ֱ��ͼ�����ݾ��鹫ʽ����29��ͳ������
subplot(311);hist(y1,29),title('randn����');
subplot(312);hist(y2,29),title('wgn����');
subplot(313);hist(y3-1,29),title('awgn����');

figure;%������غ����͹������ܶ�
subplot(331),plot(y1),title('randn���� ʱ����');
subplot(332),plot(linspace(-1000,1000,1999),xcorr(y1,'coeff')),title('����غ���');
subplot(333),plot(abs(fft(y11))),title('�������ܶ�');
% figure;
subplot(334),plot(y2),title('wgn ʱ����');
subplot(335),plot(linspace(-1000,1000,1999),xcorr(y2,'coeff')),title('����غ���');
subplot(336),plot(abs(fft(y22))),title('�������ܶ�');
% figure;
subplot(337),plot(y3),title('awgn ʱ����');
subplot(338),plot(linspace(-1000,1000,1999),xcorr(y3-1,'coeff')),title('����غ���');
subplot(339),plot(abs(fft(y33))),title('�������ܶ�');


