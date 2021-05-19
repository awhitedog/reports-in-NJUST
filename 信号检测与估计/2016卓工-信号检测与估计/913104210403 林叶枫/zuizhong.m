close all;
clear all;
clc;
y=0;
T=2e-4;                          %时宽
B=3e6;                           %带宽
K=B/T;                           %调频斜率
Fs=B;Ts=1/Fs;  
N=T/Ts+1;                        %采样点数
t=0:Ts:T;
NUM=50;                          %相干积累周期数
St=exp(j*pi*K*t.^2);             %发射信号
C=3e8;               %光速
R=[5100,5100];       %距离
V=[10,15];           %速度
A=[1,25];             %幅度
f0=10e9;             %载频 
lambda=C/f0;         %波长
for i=1:2          %目标数目
t0=floor(2*R(i)*Fs/C)+1;     %延时的点数
Sr=repmat(St,1,NUM);        %相干积累
sr=[Sr(NUM*N-t0+1:NUM*N) Sr(1:NUM*N-t0)].*A(i);      %延时
%  for fd=0:100:3000;
 fd=2*V(i)/lambda ;              %多普勒频率
t=0:Ts:(N*NUM-1)*Ts;
Sd=exp(2*j*pi*fd*t);            %产生多普勒信号
SR=sr.*Sd;                      %回波信号
y=y+SR;
end
 SNR=-10;                        %信噪比
s=awgn(SR,SNR,'measured');      %加入噪声
s1=s-y;                       %纯噪声
%%______________________脉压___________________________
h=fliplr(St) ;            %构造匹配滤波器
pipei=conv(conj(h),y);    %对回波进行匹配滤波
 figure(3)
pipei_db=10*log10(abs(pipei.^2));
%%_____计算噪声功率_______
n=abs(pipei.^2);
pn_maiya=10*log10(sum(n(:))/(N*50))%所有点对应的噪声功率求和再除以总点数
%% ______________________ 
% plot(pipei_db);
% title('脉压/db')
% axis on;grid on;
% figure(4)
% plot(abs(pipei));
% title('脉压(幅度)');
%%__________主瓣高度与多普勒的关系________
% figure(5)
% zhugaodu=10*log10(max(abs(pipei(:).^2)));  
% plot(fd,zhugaodu(),'o');
% hold on;
% axis([-inf,inf,10,90]);grid on;
% xlabel('多普勒频率/Hz');
% ylabel('主瓣高度/db')
% title('主瓣高度与多普勒频率的关系')
% end
%%_______________________结束_________________________
%%_______________________距离门重排后fft______________
for r=1:50
    for h=1:N
        f_pipei(h,r)=pipei((r-1)*N+h);
    end
end
for h=1:N
    ff_pipei(h,:)=abs((fft(f_pipei(h,:))));
end

% % ____________计算噪声与信号功率__________
n=(ff_pipei).^2;
pn_fft=10*log10(sum(n(:))/(N*50))
ps_fft=10*log10((max( ff_pipei(:)).^2))
% %_______________________________________
figure(5)
v= (0:NUM-1).*0.5*lambda*1/T/NUM;  %速度
r=(0:N-1).*Ts*C/2;                 %距离
mesh(v,r,20*log10(ff_pipei));
xlabel('速度');ylabel('距离');zlabel('幅值')
%距离5000，速度10
% mesh(1:NUM,1:N,20*log10(y));
% x=6:1:10;
% z=20*log10(y(101,x));
% xi=6:0.01:10;
% zi=interp1(x,z,xi,'cublic');
% figure(6)
% plot(xi,zi);
% axis([-inf,inf,78,90]);grid on;
% set(gca,'ytick',[83.66,87.66],'Xtick',[7.274,8.417]);
% 
