
close all 
clear all
clc
fs=1/(200*1e-6)*8192;%采样频率
f2=1/15*1e6;
% m=(0.3*f2)/(fs);
% M=round(8/m);%定义窗函数的长度
% N=M-1;%定义滤波器的阶数
% b=fir1(N,f2/fs);
% figure(1)
% [h,w]=freqz(b,1,4096);
% 
% plot(w*fs/(pi),20*log10(abs(h)))
% axis([0 1e5 -inf inf])

%噪声
% figure(2)
% wgns=wgn(1,262144,10);
% plot(wgns)
% axis tight
% nfft=16384;
% Y=fft(wgns,nfft);
% Ayy=(abs(Y));
% Ayy(1)=Ayy(1)/2;
% fs=1/(200*1e-6)*4096;
% nfft=16384;
% F=([1:nfft]-1)*fs/nfft*2; 
% figure(3)
% plot(F(1:nfft/2),Ayy(1:nfft/2));xlabel('频率'),ylabel('FFT输出')
% axis tight
% figure(12)
% out_n=filter(b,1,wgns);%滤波
% Y=fft(out_n,nfft);
% Ayy=(abs(Y));
% Ayy(1)=Ayy(1)/2;
% fs=1/(200*1e-6)*4096;
% nfft=16384;
% F=([1:nfft]-1)*fs/nfft*2; 
% plot(F(1:nfft/2),Ayy(1:nfft/2));xlabel('频率'),ylabel('FFT输出')
% axis([0 70000 -inf inf])
% plot(real(Y))
% figure (5)
% plot(1:length(out_n),real(out_n))

%------------------------------------------------------
B_tau=[];
for p=1:50
    m=p*20; 
wgns=wgn(1,262144,10);
HW=fft(wgns);
HW(m:length(HW)-m+1)=zeros(1,length(HW(m:length(HW)-m+1)));
ht=ifft(HW);
%  figure(10)
%  plot(real(ht))


%---------------------------------------------------------------------


% plot(wgns)
% nfft=16384;
% Y=fft(wgns,nfft);
% Ayy=(abs(Y));
% Ayy(1)=Ayy(1)/2;
% F=([1:nfft]-1)*fs/nfft; 
% figure(3)

% plot(F(1:nfft),Ayy(1:nfft));xlabel('频率'),ylabel('FFT输出')
% figure(4)
% out_n=filter(b,1,wgns);%滤波
% Y=fft(out_n,nfft);
% Ayy=(abs(Y));
% Ayy(1)=Ayy(1)/2;
% F=([1:nfft]-1)*fs/nfft; 
% plot(F(1:nfft/2),Ayy(1:nfft/2));xlabel('频率'),ylabel('FFT输出')
% plot(real(Y))
% figure (5)
% plot(1:length(out_n),real(out_n))



%-------------------------------------------------------------------------
out_n=real(ht);
%-------------------------------------------------------------------------


%仿真基本数据信息
tau=15;                 %脉宽为15us
prf=200;                %脉冲重复周期为200us
dr=tau/prf*100;         %占空比（duty ratio）
caf=10e9;               %载频（carrier frequency）为10GHz
c=3e8;                  %光速
SNRi=-10;               %输入信噪比
Rmin=0;                 %最近距离
Rmax=10000;             %最远距离
Npulse=32;             %相干积累脉冲个数

%目标参数
R=8000;                 %######目标距离######
v=0;                   %######目标速度，单位m/s########
fd=2*v*caf/c;           %多普勒频率
RCS=1;                  %雷达散射截面积
n=8192;                 %一个周期采样点数
Ts=prf/n;               %??????采样间隔??????
N=Npulse*n;             %??????采样点数??????

%产生周期矩形脉冲,脉宽为15us，周期为200us
% figure(6)               %图形一，产生周期矩形脉冲及回波
t=linspace(-Npulse*prf,Npulse*prf,2*N);
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
sr_t_fft=out_n;
% plot(t,real(sr_t_fft)),%axis([0 Npulse*prf -inf inf]);
% title('回波脉冲')
% xlabel('t/\mus')
% ylabel('sr(t)')
%脉压
hi_t=0.5*(square(-t*2*pi/prf,tau/prf*100)+1).*(-200<t&t<0);
% figure(7)               %图形二脉压测出距离，FFT测出速度
%subplot(2,1,1) 
%plot(t,hi_t);
so_t=conv(sr_t_fft,hi_t);
% so_t_wn=conv(sr_t,hi_t);
L=2*2*N-1;
t1=linspace(-2*Npulse*prf,2*Npulse*prf,L);
% subplot(2,1,1) 
% plot(t1,real(so_t))
%axis([-200 7200 -inf inf])
% xlabel('时间 \mus'),ylabel('脉压输出')




%------------------------------------------------------------------------
 
% 
 disp('--------------------输入信噪比为-----------------------------')
ip_n=sum(abs(out_n).^2)/length(out_n)



disp('输出信噪比为')

o_n=[];
for i=1:length(so_t)
    if so_t(i)~=0
        o_n(length(o_n)+1)=so_t(i);
    end
end
op_n=sum(abs(o_n).^2)/length(out_n)

 disp('增益为：')

B_tau(p)=(307*2)^2*ip_n/op_n;
B_tau(p)
end
f_n=(1:50)*156.25*20/1e6*2;
plot(f_n,B_tau)
xlabel('噪声带宽 MHz')
ylabel('脉压增益')