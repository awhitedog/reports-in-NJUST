
close all 
clear all
clc
fs=1/(200*1e-6)*8192;%����Ƶ��
f2=1/15*1e6;
% m=(0.3*f2)/(fs);
% M=round(8/m);%���崰�����ĳ���
% N=M-1;%�����˲����Ľ���
% b=fir1(N,f2/fs);
% figure(1)
% [h,w]=freqz(b,1,4096);
% 
% plot(w*fs/(pi),20*log10(abs(h)))
% axis([0 1e5 -inf inf])

%����
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
% plot(F(1:nfft/2),Ayy(1:nfft/2));xlabel('Ƶ��'),ylabel('FFT���')
% axis tight
% figure(12)
% out_n=filter(b,1,wgns);%�˲�
% Y=fft(out_n,nfft);
% Ayy=(abs(Y));
% Ayy(1)=Ayy(1)/2;
% fs=1/(200*1e-6)*4096;
% nfft=16384;
% F=([1:nfft]-1)*fs/nfft*2; 
% plot(F(1:nfft/2),Ayy(1:nfft/2));xlabel('Ƶ��'),ylabel('FFT���')
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

% plot(F(1:nfft),Ayy(1:nfft));xlabel('Ƶ��'),ylabel('FFT���')
% figure(4)
% out_n=filter(b,1,wgns);%�˲�
% Y=fft(out_n,nfft);
% Ayy=(abs(Y));
% Ayy(1)=Ayy(1)/2;
% F=([1:nfft]-1)*fs/nfft; 
% plot(F(1:nfft/2),Ayy(1:nfft/2));xlabel('Ƶ��'),ylabel('FFT���')
% plot(real(Y))
% figure (5)
% plot(1:length(out_n),real(out_n))



%-------------------------------------------------------------------------
out_n=real(ht);
%-------------------------------------------------------------------------


%�������������Ϣ
tau=15;                 %����Ϊ15us
prf=200;                %�����ظ�����Ϊ200us
dr=tau/prf*100;         %ռ�ձȣ�duty ratio��
caf=10e9;               %��Ƶ��carrier frequency��Ϊ10GHz
c=3e8;                  %����
SNRi=-10;               %���������
Rmin=0;                 %�������
Rmax=10000;             %��Զ����
Npulse=32;             %��ɻ����������

%Ŀ�����
R=8000;                 %######Ŀ�����######
v=0;                   %######Ŀ���ٶȣ���λm/s########
fd=2*v*caf/c;           %������Ƶ��
RCS=1;                  %�״�ɢ������
n=8192;                 %һ�����ڲ�������
Ts=prf/n;               %??????�������??????
N=Npulse*n;             %??????��������??????

%�������ھ�������,����Ϊ15us������Ϊ200us
% figure(6)               %ͼ��һ���������ھ������弰�ز�
t=linspace(-Npulse*prf,Npulse*prf,2*N);
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
sr_t_fft=out_n;
% plot(t,real(sr_t_fft)),%axis([0 Npulse*prf -inf inf]);
% title('�ز�����')
% xlabel('t/\mus')
% ylabel('sr(t)')
%��ѹ
hi_t=0.5*(square(-t*2*pi/prf,tau/prf*100)+1).*(-200<t&t<0);
% figure(7)               %ͼ�ζ���ѹ������룬FFT����ٶ�
%subplot(2,1,1) 
%plot(t,hi_t);
so_t=conv(sr_t_fft,hi_t);
% so_t_wn=conv(sr_t,hi_t);
L=2*2*N-1;
t1=linspace(-2*Npulse*prf,2*Npulse*prf,L);
% subplot(2,1,1) 
% plot(t1,real(so_t))
%axis([-200 7200 -inf inf])
% xlabel('ʱ�� \mus'),ylabel('��ѹ���')




%------------------------------------------------------------------------
 
% 
 disp('--------------------���������Ϊ-----------------------------')
ip_n=sum(abs(out_n).^2)/length(out_n)



disp('��������Ϊ')

o_n=[];
for i=1:length(so_t)
    if so_t(i)~=0
        o_n(length(o_n)+1)=so_t(i);
    end
end
op_n=sum(abs(o_n).^2)/length(out_n)

 disp('����Ϊ��')

B_tau(p)=(307*2)^2*ip_n/op_n;
B_tau(p)
end
f_n=(1:50)*156.25*20/1e6*2;
plot(f_n,B_tau)
xlabel('�������� MHz')
ylabel('��ѹ����')