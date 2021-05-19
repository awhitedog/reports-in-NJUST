%�����ļ�:PDR_Simulation2.m
%Ŀ�ģ�����������״Pulse-Doppler radar������
%      ���˲����������
%
% ���ļ�¼
% Date   Programmer  Description of change
% ====   =========      ================
% 16/4/25    CKJ          Original code
%
% ˵��
% 1�������ģ�������ٶ�Ϊ37.5m/s
%
%--------------------------------------------------------
%--------------------------------------------------------

%׼������
clear all
close all

%===========================����һ����Ŀ�����============================

%�������������Ϣ
tau=15;                 %����Ϊ15us
prf=200;                %�����ظ�����Ϊ200us
dr=tau/prf*100;         %ռ�ձȣ�duty ratio��
caf=10e9;               %��Ƶ��carrier frequency��Ϊ10GHz
c=3e8;                  %����
SNRi=-20;               %���������
Rmin=0;                 %�������
Rmax=10000;             %��Զ����
Npulse=32;              %��ɻ����������
fs=20480000;

%Ŀ�����
R=8000;                 %######Ŀ�����######
v=-20;                   %######Ŀ���ٶȣ���λm/s########
fd=2*v*caf/c;           %������Ƶ��
RCS=1;                  %�״�ɢ������
n=4096;                 %һ�����ڲ�������
Ts=prf/n;               %??????�������??????
N=Npulse*n;             %??????��������??????

%�������ھ�������,����Ϊ15us������Ϊ200us
figure(1)               %ͼ��һ���������ھ������弰�ز�
t=linspace(-Npulse*prf,Npulse*prf,2*N);
si_t=0.5*(square(t*2*pi/prf,tau/prf*100)+1).*(t>0);
subplot(2,1,1)
fg1=plot(t,si_t);axis([0 Npulse*prf -inf inf]);title('���ھ�������')
xlabel('t/\mus');ylabel('si(t)')

%�ز��ź�
td=t-2*R/c*1e6;
subplot(2,1,2);
si_td=RCS*(0.5*(square(td*2*pi/prf,tau/prf*100)+1)).*(t>0);
mm=exp(j*2*pi*fd*td/1e6);
sr_t=mm.*si_td;

%���������ź�%

%-------------------------------------------------------------------------%
wgns=wgn(1,length(sr_t),10);
HW=fft(wgns);
HW(428:length(HW)-427)=zeros(1,length(HW(428:length(HW)-427)));
ht=ifft(HW);
out_n=real(ht);
%-------------------------------------------------------------------------%


%��������
sr_t_fft=sr_t+out_n;
plot(t,real(sr_t_fft)),axis([0 Npulse*prf -inf inf]);
title('�ز�����')
xlabel('t/\mus')
ylabel('sr(t)')

%�Լ�����������ź�FFT
%-------------------------------------------------------------------------%
% figure(10)
% nfft_n=16384;
% fft_n=fft(sr_t_fft,nfft_n);
% F1=([1:nfft_n]-1)*fs/nfft_n*2;
% plot(F1(1:nfft_n/2),real(fft_n(1:nfft_n/2)))
% axis([0 100000 -inf inf])
%  xlabel('Ƶ��')
%  ylabel('FFT���')
 
%-------------------------------------------------------------------------%
%��ѹ
hi_t=0.5*(square(-t*2*pi/prf,tau/prf*100)+1).*(-200<t&t<0);
figure(2)               %ͼ�ζ���ѹ������룬FFT����ٶ�
%subplot(2,1,1) 
%plot(t,hi_t);
so_t=conv(sr_t_fft,hi_t);
% so_t_wn=conv(sr_t,hi_t);
L=2*2*N-1;
t1=linspace(-2*Npulse*prf,2*Npulse*prf,L);
subplot(2,1,1) 
plot(t1,real(so_t))
% axis([-200 7200 -inf inf])
xlabel('ʱ�� \mus'),ylabel('��ѹ���')
subplot(2,1,2) 
plot(t1*c/1e6/2,real(so_t))
%axis tight
axis([0 10000 -inf inf]);
xlabel('���� m'),ylabel('��ѹ���')

%����ѹ����ź�FFT
%-------------------------------------------------------------------------%
% figure(11)
% nfft_n=16384*16;
% fft_n=fft(so_t,nfft_n);
% % plot(real(fft_n))
%  F1=([1:nfft_n]-1)*fs/nfft_n*2;
%  plot(F1(1:nfft_n),real(fft_n(1:nfft_n)))
%  axis([0 100000 -inf inf])
%  xlabel('Ƶ��')
%  ylabel('FFT���')
%-------------------------------------------------------------------------%
%����������
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
     %view(90,0)              % yozƽ��
     %view(0,90)              % xoyƽ��
%      grid on
 end
figure(9);
plot(t_m*c/2/1e6,real(m1-m2));
axis([0 12000 -inf inf])
figure(3);
A=size(h);
h_x=((0:A(1)-1)*c*200/4096/1e6)/2;
h_y=(1:A(2));
mesh(h_y,h_x,abs(h))                   %���������Ž��������ȡģ

xlabel('�����Ŵ���'),ylabel('���� m'),zlabel('��ѹ���')
figure(4)
g=fft(h,[],2);
B=size(g);
g_x=((0:B(1)-1)*c*200/n/1e6)/2;  
g_y=[(1:Npulse/2)-1 (-1:-1:-Npulse/2)];
g_y=g_y*(1e6/prf)/Npulse*c/caf/2;
mesh(1:Npulse,g_x,20*log10(abs(g)))
% set(gca,'XTick',0:3.3438:37.5)  
% set(gca,'XTickLabel',{'-40','-30',,'0','10','20','30','40','-10','-20'}) 
xlabel('����'),ylabel('����'),zlabel('FFT���')
% B=size(g);
% g_x=((0:B(1)-1)*c*200/n/1e6)/2;     %����ɾ���
% g_y=[(1:Npulse/2)-1 (-1:-1:-Npulse/2)];
% g_y=g_y*(1e6/prf)/Npulse*c/caf/2;
% figure(4);
% %ʵ������ͼ
% mesh(g_y(1:Npulse),g_x,20*log10(abs(g(:,1:Npulse))))
% % g=fft(h,[],2);
% B=size(g);
% g_x=((0:B(1)-1)*c*200/n/1e6)/2;     %����ɾ���
% g_y=[(1:Npulse/2)-1 (-1:-1:-Npulse/2)];
% g_y=g_y*(1e6/prf)/Npulse*c/caf/2;
% figure(4);
% %ʵ������ͼ
% mesh(g_y(1,1:Npulse),g_x,20*log10(abs(g(:,1:Npulse))))
% xlabel('����'),ylabel('�ٶ�'),zlabel('FFT���')
% axis([-inf inf 0 12000 -inf inf])
% break
% hold off
% figure
% subplot(2,1,1)
% plot(t_h*c/1e6/2,h1)
% subplot(2,1,2)
% plot(t_h*c/1e6/2,h2)

% %===========================����������������з���==========================
% figure(10)
% for a=1:100
%     v=-1000+20*a;
%     fd=2*v*caf/c;
%     si_td=RCS*(0.5*(square(td*2*pi/prf,tau/prf*100)+1)).*(t>0);
%     mm=exp(j*2*pi*fd*td/1e6);
%     sr_t=mm.*si_td;
%     hi_t=0.5*(square(-t*2*pi/prf,tau/prf*100)+1).*(-200<t&t<0);  %ͼ�ζ���ѹ������룬FFT����ٶ�
%     so_t=conv(sr_t,hi_t);
%     so_max(a)=max(abs(so_t)); %�����������õ����
%     freq(a)=fd;          %�����������õ����
% %     f=so_t(1,1:length(so_t));
% %     an=fd*ones(1,length(so_t)); 
% %     plot3(an,t1,real(f))
% %     hold on
% %     ylabel('t \mus');
% %     xlabel('fd Hz');
% %     zlabel('��ѹ���')
% %axis([-inf inf 0 6400 -inf inf])
% end
% plot(freq,so_max)
% xlabel('Ƶ��')
% ylabel('��ѹ������ֵ')
% grid on
% % v=0;
% % fd=2*v*caf/c;
% % si_td=RCS*(0.5*(square(td*2*pi/prf,tau/prf*100)+1)).*(t>0);
% % mm=exp(j*2*pi*fd*td/1e6);
% % sr_t=mm.*si_td;
% % hi_t=0.5*(square(-t*2*pi/prf,tau/prf*100)+1).*(-200<t&t<0);  %ͼ�ζ���ѹ������룬FFT����ٶ�
% % so_t=conv(sr_t,hi_t);
% % an0=zeros(1,length(so_t));
% % plot3(an0,t1,real(so_t),'g')
% % hold off

%=============================����������Ŀ�����============================
RCS=[1,4];
R=[8000,8000];
v=[26,30];
figure(5)                %ͼ��������Ŀ��ز�
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

%��������
% sr_td_fft=awgn(sr_td,SNRi,'measured');
% subplot(4,1,4)
% plot(t,real(sr_t_fft)),axis([0 Npulse*prf/4 -inf inf]);

%��ѹ
hi_t=0.5*(square(-t*2*pi/prf,tau/prf*100)+1).*(-200<t&t<0);
figure(6)               %ͼ�ζ���ѹ������룬FFT����ٶ�
so_td=conv(sr_td,hi_t)/307;
L=2*2*N-1;
t1=linspace(-2*Npulse*prf,2*Npulse*prf,L);
subplot(2,1,1) 
plot(t1,real(so_td))
subplot(2,1,2) 
plot(t1*c/1e6/2,real(so_td))
%axis tight
axis([0 10000 -inf inf]);
xlabel('����'),ylabel('��ѹ���')
%����������
p=zeros(n+1,Npulse);
for i=1:Npulse
    p(:,i)=so_td(1,((i-1)*n+2*N+1):(i*n+2*N+1));
end   
figure(7)
A=size(p);
p_x=((0:A(1)-1)*c*200/4096/1e6)/2;
p_y=(1:A(2));
mesh(p_y,p_x,abs(p))                   %���������Ž��������ȡģ

%FFT*
%q=fft(p,[],2);
q=fft(p,Npulse,2);
B=size(q);
q_x=((0:B(1)-1)*c*200/n/1e6)/2;     %����ɾ���
q_y=[(1:Npulse/2)-1 (-1:-1:-Npulse/2)];
q_y=q_y*(1e6/prf)/Npulse*c/caf/2;
figure(8);
%����ͼ
mesh(q_y(1,1:Npulse),q_x,10*log10(abs(q(:,1:Npulse))))
% zoom on
% [tt,yy,zz]=ginput(100);
% zoom off;
%
% tt