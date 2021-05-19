
clear all;
clc;
%================================����==================================
fm=2e6;%��Ƶ
fc=10e9;%��Ƶ
c=3e8;%����
t=10e-3;%��ɻ�����ʱ��
T=1/fm*1270;%��λ��������
N=15;%�����ظ�����(t/T)
snr0=10;%Ŀ��ز���������ȣ�-35~10dB��
d=1000;%Ŀ�����(0~10000m)
v=0;%Ŀ���ٶȣ�0~1000m/s��
A=1;%Ŀ����ȣ�1~100��
m=1270;%һ�������ڵĲ��������
t1=2*d/c;%��ʱ
n1=fix(t1/5e-7);%��ʱ�������
%==============================m���в���=================================
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
m_bip=2*mseqmatrix-1;%˫ֵ��ƽ
%=============================��Ŀ��====================================
m_1270=[m_bip zeros(1,1143)];%ռ�ձ�10%����
snr=snr0-10;
hb=repmat(m_1270,1,N);
clear j;
%---------------------------�ز�---------------------------------------%
hb=[zeros(1,n1) hb(1:1270*N-n1)]*A;%����ʱ
fd=2*v/(c/fc);
duopule=exp(j*2*pi.*(1:1:1270*N)*fd/fm);
hb1=hb.*duopule;%�Ӷ�����
hb2=awgn(hb1,snr,'measured');%������
%------------------------��ѹ���SNR����--------------------------------%
pipei=fliplr(m_1270);%�����ش�ֱ�����ҷ�ת
hbb1=conv(pipei,hb1);%������
hbb2=conv(pipei,hb2);%������
hbb3=hbb2-hbb1;
%--------����������---------------%
for r=1:N
for h=1:m
s_hb1(h,r)=hbb1((r-1)*m+h);
s_hb2(h,r)=hbb2((r-1)*m+h);
s_hb3(h,r)=hbb3((r-1)*m+h);
end
end
pp=10*log10(max(max(abs(real(s_hb1))))*max(max(abs(real(s_hb1)))));
pn=s_hb3.*s_hb3;
pn=sum(abs(real(pn(:))))/1270/N;
pn=10*log10(pn);
snr1=pp-pn;
snr1;
%---------------------------------
for h=1:m
r_fft1(h,:)=abs(fft(s_hb1(h,:)));   
r_fft3(h,:)=abs(fft(s_hb3(h,:)));
end
pp1=10*log10(max(max(r_fft1))*max(max(r_fft1)));
pn1=r_fft3.*r_fft3;
pn1=sum(pn1(:))/1270/N;
pn1=10*log10(pn1);
snr2=pp1-pn1;
snr2;

