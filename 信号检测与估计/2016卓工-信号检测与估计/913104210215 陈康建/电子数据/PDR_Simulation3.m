%代码文件:PDR_Simulation2.m
%目的：脉冲多普勒雷达（Pulse-Doppler radar）仿真
%      加滤波器后的噪声
%
% 更改记录
% Date   Programmer  Description of change
% ====   =========      ================
% 16/4/25    CKJ          Original code
%
% 说明
% 1、最大无模糊测量速度为37.5m/s
%
%--------------------------------------------------------
%--------------------------------------------------------

%准备工作
clear all
close all

%===========================步骤一：单目标仿真============================

%仿真基本数据信息
tau=15;                 %脉宽为15us
prf=200;                %脉冲重复周期为200us
dr=tau/prf*100;         %占空比（duty ratio）
caf=10e9;               %载频（carrier frequency）为10GHz
c=3e8;                  %光速
SNRi=-20;               %输入信噪比
Rmin=0;                 %最近距离
Rmax=10000;             %最远距离
Npulse=32;              %相干积累脉冲个数
fs=20480000;

%目标参数
R=8000;                 %######目标距离######
v=-20;                   %######目标速度，单位m/s########
fd=2*v*caf/c;           %多普勒频率
RCS=1;                  %雷达散射截面积
n=4096;                 %一个周期采样点数
Ts=prf/n;               %??????采样间隔??????
N=Npulse*n;             %??????采样点数??????

%产生周期矩形脉冲,脉宽为15us，周期为200us
figure(1)               %图形一，产生周期矩形脉冲及回波
t=linspace(-Npulse*prf,Npulse*prf,2*N);
si_t=0.5*(square(t*2*pi/prf,tau/prf*100)+1).*(t>0);
subplot(2,1,1)
fg1=plot(t,si_t);axis([0 Npulse*prf -inf inf]);title('周期矩形脉冲')
xlabel('t/\mus');ylabel('si(t)')

%回波信号
td=t-2*R/c*1e6;
subplot(2,1,2);
si_td=RCS*(0.5*(square(td*2*pi/prf,tau/prf*100)+1)).*(t>0);
mm=exp(j*2*pi*fd*td/1e6);
sr_t=mm.*si_td;

%噪声产生信号%

%-------------------------------------------------------------------------%
wgns=wgn(1,length(sr_t),10);
HW=fft(wgns);
HW(428:length(HW)-427)=zeros(1,length(HW(428:length(HW)-427)));
ht=ifft(HW);
out_n=real(ht);
%-------------------------------------------------------------------------%


%加入噪声
sr_t_fft=sr_t+out_n;
plot(t,real(sr_t_fft)),axis([0 Npulse*prf -inf inf]);
title('回波脉冲')
xlabel('t/\mus')
ylabel('sr(t)')

%对加入噪声后的信号FFT
%-------------------------------------------------------------------------%
% figure(10)
% nfft_n=16384;
% fft_n=fft(sr_t_fft,nfft_n);
% F1=([1:nfft_n]-1)*fs/nfft_n*2;
% plot(F1(1:nfft_n/2),real(fft_n(1:nfft_n/2)))
% axis([0 100000 -inf inf])
%  xlabel('频率')
%  ylabel('FFT输出')
 
%-------------------------------------------------------------------------%
%脉压
hi_t=0.5*(square(-t*2*pi/prf,tau/prf*100)+1).*(-200<t&t<0);
figure(2)               %图形二脉压测出距离，FFT测出速度
%subplot(2,1,1) 
%plot(t,hi_t);
so_t=conv(sr_t_fft,hi_t);
% so_t_wn=conv(sr_t,hi_t);
L=2*2*N-1;
t1=linspace(-2*Npulse*prf,2*Npulse*prf,L);
subplot(2,1,1) 
plot(t1,real(so_t))
% axis([-200 7200 -inf inf])
xlabel('时间 \mus'),ylabel('脉压输出')
subplot(2,1,2) 
plot(t1*c/1e6/2,real(so_t))
%axis tight
axis([0 10000 -inf inf]);
xlabel('距离 m'),ylabel('脉压输出')

%对脉压后的信号FFT
%-------------------------------------------------------------------------%
% figure(11)
% nfft_n=16384*16;
% fft_n=fft(so_t,nfft_n);
% % plot(real(fft_n))
%  F1=([1:nfft_n]-1)*fs/nfft_n*2;
%  plot(F1(1:nfft_n),real(fft_n(1:nfft_n)))
%  axis([0 100000 -inf inf])
%  xlabel('频率')
%  ylabel('FFT输出')
%-------------------------------------------------------------------------%
%距离门重排
m1=zeros(1,n+1);
m2=zeros(1,n+1);
h=zeros(n+1,Npulse);
for i=1:Npulse
     h(:,i)=so_t(1,((i-1)*n+2*N+1):(i*n+2*N+1));
     m=so_t(1,((i-1)*n+2*N+1):(i*n+2*N+1));
%      i_n=i*ones(1,length(h));
     t_m=0:Ts:200;
%       plot3((i_n),t_h*c/1e6/2,h),%axis([-inf inf 0 10000 -inf inf])
%       hold on
     if max(m)>abs(min(m))  
         m1=m1+m;
     else
         m2=m2+m;
     end
     %view(90,0)              % yoz平面
     %view(0,90)              % xoy平面
%      grid on
 end
figure(9);
plot(t_m*c/2/1e6,real(m1-m2));
axis([0 12000 -inf inf])
figure(3);
A=size(h);
h_x=((0:A(1)-1)*c*200/4096/1e6)/2;
h_y=(1:A(2));
mesh(h_y,h_x,abs(h))                   %距离门重排结果，复数取模

xlabel('距离门次序'),ylabel('距离 m'),zlabel('脉压输出')
figure(4)
g=fft(h,[],2);
B=size(g);
g_x=((0:B(1)-1)*c*200/n/1e6)/2;  
g_y=[(1:Npulse/2)-1 (-1:-1:-Npulse/2)];
g_y=g_y*(1e6/prf)/Npulse*c/caf/2;
mesh(1:Npulse,g_x,20*log10(abs(g)))
% set(gca,'XTick',0:3.3438:37.5)  
% set(gca,'XTickLabel',{'-40','-30',,'0','10','20','30','40','-10','-20'}) 
xlabel('点数'),ylabel('距离'),zlabel('FFT输出')
% B=size(g);
% g_x=((0:B(1)-1)*c*200/n/1e6)/2;     %换算成距离
% g_y=[(1:Npulse/2)-1 (-1:-1:-Npulse/2)];
% g_y=g_y*(1e6/prf)/Npulse*c/caf/2;
% figure(4);
% %实数处理画图
% mesh(g_y(1:Npulse),g_x,20*log10(abs(g(:,1:Npulse))))
% % g=fft(h,[],2);
% B=size(g);
% g_x=((0:B(1)-1)*c*200/n/1e6)/2;     %换算成距离
% g_y=[(1:Npulse/2)-1 (-1:-1:-Npulse/2)];
% g_y=g_y*(1e6/prf)/Npulse*c/caf/2;
% figure(4);
% %实数处理画图
% mesh(g_y(1,1:Npulse),g_x,20*log10(abs(g(:,1:Npulse))))
% xlabel('距离'),ylabel('速度'),zlabel('FFT输出')
% axis([-inf inf 0 12000 -inf inf])
% break
% hold off
% figure
% subplot(2,1,1)
% plot(t_h*c/1e6/2,h1)
% subplot(2,1,2)
% plot(t_h*c/1e6/2,h2)

% %===========================步骤二：多普勒敏感仿真==========================
% figure(10)
% for a=1:100
%     v=-1000+20*a;
%     fd=2*v*caf/c;
%     si_td=RCS*(0.5*(square(td*2*pi/prf,tau/prf*100)+1)).*(t>0);
%     mm=exp(j*2*pi*fd*td/1e6);
%     sr_t=mm.*si_td;
%     hi_t=0.5*(square(-t*2*pi/prf,tau/prf*100)+1).*(-200<t&t<0);  %图形二脉压测出距离，FFT测出速度
%     so_t=conv(sr_t,hi_t);
%     so_max(a)=max(abs(so_t)); %多普勒容限用到语句
%     freq(a)=fd;          %多普勒容限用到语句
% %     f=so_t(1,1:length(so_t));
% %     an=fd*ones(1,length(so_t)); 
% %     plot3(an,t1,real(f))
% %     hold on
% %     ylabel('t \mus');
% %     xlabel('fd Hz');
% %     zlabel('脉压输出')
% %axis([-inf inf 0 6400 -inf inf])
% end
% plot(freq,so_max)
% xlabel('频率')
% ylabel('脉压输出最大值')
% grid on
% % v=0;
% % fd=2*v*caf/c;
% % si_td=RCS*(0.5*(square(td*2*pi/prf,tau/prf*100)+1)).*(t>0);
% % mm=exp(j*2*pi*fd*td/1e6);
% % sr_t=mm.*si_td;
% % hi_t=0.5*(square(-t*2*pi/prf,tau/prf*100)+1).*(-200<t&t<0);  %图形二脉压测出距离，FFT测出速度
% % so_t=conv(sr_t,hi_t);
% % an0=zeros(1,length(so_t));
% % plot3(an0,t1,real(so_t),'g')
% % hold off

%=============================步骤三：多目标仿真============================
RCS=[1,4];
R=[8000,8000];
v=[26,30];
figure(5)                %图形三：多目标回波
td=ones(length(R),1)*t-2*R'/c*ones(1,2*N)*1e6;
fd=2*v*caf/c;
sr_td1=RCS(1)*(0.5*(square(td(1,:)*2*pi/prf,tau/prf*100)+1)).*(t>0)...
       .*exp(2*j*pi*fd(1)*td(1,:)/1e6);
subplot(3,1,1)
plot(t,real(sr_td1)),axis([0 Npulse*prf/4 -inf inf]);
sr_td2=RCS(2)*(0.5*(square(td(2,:)*2*pi/prf,tau/prf*100)+1)).*(t>0)...
       .*exp(2*j*pi*fd(2)*td(2,:)/1e6);
subplot(3,1,2)
plot(t,real(sr_td2)),axis([0 Npulse*prf/4 -inf inf]);
sr_td=sr_td1+sr_td2;
subplot(3,1,3)
plot(t,real(sr_td)),axis([0 Npulse*prf/4 -inf inf]);

%加入噪声
% sr_td_fft=awgn(sr_td,SNRi,'measured');
% subplot(4,1,4)
% plot(t,real(sr_t_fft)),axis([0 Npulse*prf/4 -inf inf]);

%脉压
hi_t=0.5*(square(-t*2*pi/prf,tau/prf*100)+1).*(-200<t&t<0);
figure(6)               %图形二脉压测出距离，FFT测出速度
so_td=conv(sr_td,hi_t)/307;
L=2*2*N-1;
t1=linspace(-2*Npulse*prf,2*Npulse*prf,L);
subplot(2,1,1) 
plot(t1,real(so_td))
subplot(2,1,2) 
plot(t1*c/1e6/2,real(so_td))
%axis tight
axis([0 10000 -inf inf]);
xlabel('距离'),ylabel('脉压输出')
%距离门重排
p=zeros(n+1,Npulse);
for i=1:Npulse
    p(:,i)=so_td(1,((i-1)*n+2*N+1):(i*n+2*N+1));
end   
figure(7)
A=size(p);
p_x=((0:A(1)-1)*c*200/4096/1e6)/2;
p_y=(1:A(2));
mesh(p_y,p_x,abs(p))                   %距离门重排结果，复数取模

%FFT*
%q=fft(p,[],2);
q=fft(p,Npulse,2);
B=size(q);
q_x=((0:B(1)-1)*c*200/n/1e6)/2;     %换算成距离
q_y=[(1:Npulse/2)-1 (-1:-1:-Npulse/2)];
q_y=q_y*(1e6/prf)/Npulse*c/caf/2;
figure(8);
%处理画图
mesh(q_y(1,1:Npulse),q_x,10*log10(abs(q(:,1:Npulse))))
% zoom on
% [tt,yy,zz]=ginput(100);
% zoom off;
%
% tt