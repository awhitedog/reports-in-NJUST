clc;close all;clear all;
M=13
A = xlsread(['E:\baogao\雷达信号处理\数据3\ALL00',num2str(M),'\F00',num2str(M),'CH1.csv']);%数据存储位置
x1=A(:,3);
y1=A(:,4);
figure(2)
plot(x1,y1,'r');
axis tight;
B = xlsread(['E:\baogao\雷达信号处理\数据3\ALL00',num2str(M),'\F00',num2str(M),'CH2.csv']);
x2=B(:,3);
y2=B(:,4);
figure(1)
subplot(2,1,1)
plot(x1,y1,'r');
axis tight;
figure(1)
subplot(2,1,2)
plot(x2,y2,'b');
axis tight;
figure(3)
plot(x2,y2,'b');
axis tight;
