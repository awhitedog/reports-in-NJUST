d=[];
for Nord=1:100
clear all
close all
tau=15;                 %脉宽为15us
prf=200;                %脉冲重复周期为200us
dr=tau/prf*100;         %占空比（duty ratio）
caf=10e9;               %载频（carrier frequency）为10GHz
c=3e8;                  %光速  
SNRi=-10;               %输入信噪比
Rmin=0;                 %最近距离
Rmax=10000;             %最远距离
Npulse=30;             %相干积累脉冲个数

%目标参数
R=8000;                 %######目标距离######
v=0;                   %######目标速度，单位m/s########
fd=2*v*caf/c;           %多普勒频率
RCS=1;                  %雷达散射截面积
n=4096;                 %一个周期采样点数
Ts=prf/n;               %??????采样间隔??????
N=Npulse*n;             %??????采样点数??????

%产生周期矩形脉冲,脉宽为15us，周期为200us
% figure(1)             
t=linspace(-Npulse*prf,Npulse*prf,800);
si_t=0.5*(square(t*2*pi/prf,tau/prf*100)+1).*(t>0);
% subplot(2,1,1)
% fg1=plot(t,si_t);%axis([0 Npulse*prf -inf inf]);title('周期矩形脉冲')
% xlabel('t/\mus');ylabel('si(t)')

%回波信号
td=t-2*R/c*1e6;
% subplot(2,1,2);
si_td=RCS*(0.5*(square(td*2*pi/prf,tau/prf*100)+1)).*(t>0);
mm=exp(j*2*pi*fd*td/1e6);
sr_t=mm.*si_td;

%加入噪声
out_n=wgn(1,800,0.01);
sr_t_fft=out_n;
% plot(t,real(sr_t_fft)),%axis([0 Npulse*prf -inf inf]);
% title('回波脉冲')
% xlabel('t/\mus')
% ylabel('sr(t)')

tInterp=linspace(-Npulse*prf,Npulse*prf,2*N);
sr_tInterp=interp1(t,sr_t_fft,tInterp,'spline');
% 'method'是最邻近插值， 'linear'线性插值；
%'spline'三次样条插值； 'cubic'立方插值
% figure(2)
% plot(tInterp,sr_tInterp)

%脉压
hi_t=0.5*(square(-tInterp*2*pi/prf,tau/prf*100)+1).*(-200<tInterp&tInterp<0);

% figure(3)
% plot(tInterp,hi_t)
% figure(4)              

so_t=conv(sr_tInterp,hi_t);
L=2*2*N-1;
t1=linspace(-2*Npulse*prf,2*Npulse*prf,L);

% plot(t1,real(so_t))
% axis([-200 7200 -inf inf])
% xlabel('时间 \mus'),ylabel('脉压输出')




%------------------------------------------------------------------------
 
% 
%  disp('--------------------输入噪声平均功率为-----------------------------')
ip_n=sum(abs(out_n).^2)/length(out_n);



%  disp('--------------------输出噪声平均功率为-----------------------------')

o_n=[];
for i=1:length(so_t)
    if so_t(i)~=0
        o_n(length(o_n)+1)=so_t(i);
    end
end
op_n=sum(abs(o_n).^2)/length(o_n);

% disp('--------------------输出噪声平均功率为-----------------------------')

D=(262^2/op_n)/1/ip_n
end
