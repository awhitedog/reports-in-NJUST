clear all;
N=256;dt=0.02;
n=0:N-1;t=n*dt;
x=sin(2*pi*t);
m=N;
a=zeros(1,m);b=zeros(1,m);
for k=0:m-1
    for ii=0:N-1
        a(k+1)=a(k+1)+2/N*x(ii+1)*cos(2*pi*k*ii/N);
        b(k+1)=b(k+1)+2/N*x(ii+1)*sin(2*pi*k*ii/N);
    end
c(k+1)=sqrt(a(k+1)^2+b(k+1)^2);
end
subplot(211);plot(t,x);title('原始信号'),xlabel('时间/t');
f=(0:m-1)/(N*dt);
subplot(212);plot(f,c);hold on
title('Fourier');xlabel('频率/HZ');ylabel('振幅');
ind=find(c==max(c),1,'first');%寻找最大值的位置
%%%%%%% ind = find(X, k) 或ind = find(X, k, 'first')
%   返回第一个非零元素k的索引值（顺序）。
%   k必须是一个正数，但是它可以是任何数字数值类型。

x0=f(ind); %根据位置得到横坐标（频率）
y0=c(ind); %根据位置得到纵坐标（幅度）
plot(x0,y0,'ro');hold off

%%%%%%% hold on 和hold off，是相对使用的.通常是一个图上画两个曲线进行比较。
%   前者的意思是，你在当前图的轴（坐标系）中画了一幅图，再画另一幅图时，原来的图还在，与新图共存，都看得到
%   后者表达的是，你在当前图的轴（坐标系）中画了一幅图，此时，状态是hold off,则再画另一幅图时，原来的图就看不到了，在轴上绘制的是新图，原图被替换了

text(x0+1,y0-0.1,num2str(x0,'频率=%f'));

%   text(x,y,'string')在图形中指定的位置(x,y)上显示字符串string