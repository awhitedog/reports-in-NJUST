d=[];
for Nord=1:100
clear all
close all
tau=15;                 %����Ϊ15us
prf=200;                %�����ظ�����Ϊ200us
dr=tau/prf*100;         %ռ�ձȣ�duty ratio��
caf=10e9;               %��Ƶ��carrier frequency��Ϊ10GHz
c=3e8;                  %����  
SNRi=-10;               %���������
Rmin=0;                 %�������
Rmax=10000;             %��Զ����
Npulse=30;             %��ɻ����������

%Ŀ�����
R=8000;                 %######Ŀ�����######
v=0;                   %######Ŀ���ٶȣ���λm/s########
fd=2*v*caf/c;           %������Ƶ��
RCS=1;                  %�״�ɢ������
n=4096;                 %һ�����ڲ�������
Ts=prf/n;               %??????�������??????
N=Npulse*n;             %??????��������??????

%�������ھ�������,����Ϊ15us������Ϊ200us
% figure(1)             
t=linspace(-Npulse*prf,Npulse*prf,800);
si_t=0.5*(square(t*2*pi/prf,tau/prf*100)+1).*(t>0);
% subplot(2,1,1)
% fg1=plot(t,si_t);%axis([0 Npulse*prf -inf inf]);title('���ھ�������')
% xlabel('t/\mus');ylabel('si(t)')

%�ز��ź�
td=t-2*R/c*1e6;
% subplot(2,1,2);
si_td=RCS*(0.5*(square(td*2*pi/prf,tau/prf*100)+1)).*(t>0);
mm=exp(j*2*pi*fd*td/1e6);
sr_t=mm.*si_td;

%��������
out_n=wgn(1,800,0.01);
sr_t_fft=out_n;
% plot(t,real(sr_t_fft)),%axis([0 Npulse*prf -inf inf]);
% title('�ز�����')
% xlabel('t/\mus')
% ylabel('sr(t)')

tInterp=linspace(-Npulse*prf,Npulse*prf,2*N);
sr_tInterp=interp1(t,sr_t_fft,tInterp,'spline');
% 'method'�����ڽ���ֵ�� 'linear'���Բ�ֵ��
%'spline'����������ֵ�� 'cubic'������ֵ
% figure(2)
% plot(tInterp,sr_tInterp)

%��ѹ
hi_t=0.5*(square(-tInterp*2*pi/prf,tau/prf*100)+1).*(-200<tInterp&tInterp<0);

% figure(3)
% plot(tInterp,hi_t)
% figure(4)              

so_t=conv(sr_tInterp,hi_t);
L=2*2*N-1;
t1=linspace(-2*Npulse*prf,2*Npulse*prf,L);

% plot(t1,real(so_t))
% axis([-200 7200 -inf inf])
% xlabel('ʱ�� \mus'),ylabel('��ѹ���')




%------------------------------------------------------------------------
 
% 
%  disp('--------------------��������ƽ������Ϊ-----------------------------')
ip_n=sum(abs(out_n).^2)/length(out_n);



%  disp('--------------------�������ƽ������Ϊ-----------------------------')

o_n=[];
for i=1:length(so_t)
    if so_t(i)~=0
        o_n(length(o_n)+1)=so_t(i);
    end
end
op_n=sum(abs(o_n).^2)/length(o_n);

% disp('--------------------�������ƽ������Ϊ-----------------------------')

D=(262^2/op_n)/1/ip_n
end
