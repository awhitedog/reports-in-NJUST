clc;close all;clear all;
x=1:1:1024;
y=sin(2*pi*x/900);
figure(1)
plot(y,'LineWidth',2);
 axis tight;
 hold on;
 plot([0 1024], [0.5 0.5],'--k');
 hold on;
 a=find(y>=0.5)
 b=[70,85,970,985];
 plot(x(b(1)),y(b(1)),'r*','LineWidth',2);
 plot(x(b(2)),y(b(2)),'r*','LineWidth',2);
  plot(x(b(3)),y(b(3)),'r*','LineWidth',2);
 plot(x(b(4)),y(b(4)),'r*','LineWidth',2);
 