clear all;
clc;
close all;
%=============================����==================================
fm=2e6;%��Ƶ
fc=10e9;%��Ƶ
c=3e8;%����
t=10e-3;%��ɻ�����ʱ��
T=1/fm*1270;%��λ��������
N=15;%�����ظ�����(t/T)
snr=-10;%Ŀ��ز���������ȣ�-35~10dB��
d1=8000;
d2=8000;%Ŀ�����(0~10000m)
v1=8;
v2=6;%Ŀ���ٶȣ�0~1000m/s��
A1=1;
A2=1;%Ŀ����ȣ�1~100��
m=1270;%һ�������ڵĲ��������
t1=2*d1/(3e8);
t2=2*d2/(3e8);%��ʱ
n1=round(t1/(5e-7));
n2=round(t2/(5e-7));%��ʱ�������
%==============================m���в���======================
connection=[1 0 0 0 0 0 1];
n=length(connection);
reg=[0 0 0 0 0 0 1 ];
mseqmatrix(1)=reg(n);
for i=2:127 
  newreg(1)=mod(sum(connection.*reg),2);
for j=2:n
  newreg(j)=reg(j-1);
end
reg=newreg;
mseqmatrix(i)=reg(n);
end
clear j;
m_bip=2*mseqmatrix-1;
m_1270=[m_bip zeros(1,1143)];
hb=repmat(m_1270,1,N);
%--------------------����ʱ�Ͷ����յĻز�------------------------
hb1=[zeros(1,n1) hb(1:1270*N-n1)]*A1;
hb2=[zeros(1,n2) hb(1:1270*N-n2)]*A2;
fd1=2*v1/(c/fc);
fd2=2*v2/(c/fc);
duopule1=exp(j*2*pi.*(1:1:1270*N)*fd1/fm);
duopule2=exp(j*2*pi.*(1:1:1270*N)*fd2/fm);
hb21=hb1.*duopule1;
hb22=hb2.*duopule2;
hb23=hb21+hb22;
hb31=awgn(hb23,snr,'measured');
%---------------------------��ѹ------------------------------
pipei=fliplr(m_1270);
hbb2=conv(pipei,hb31);
%--------------------------����������---------------------------
for r=1:N
for h=1:m
s_hb2(h,r)=hbb2((r-1)*m+h);
end
end
%---------------------------------
for h=1:m
r_fft(h,:)=abs(fft(s_hb2(h,:)));
end
figure;mesh(1:N,linspace(0,95250,1270),real(r_fft));
%figure;mesh(1:N,1:1270,real(r_fft));
title('FFT�����ͼ��');
xlabel('x/����������');ylabel('y/Ŀ�����');zlabel('z/Ŀ�����');