clear all;
clc;
%========================����========================
fm=2e6;%��Ƶ
fc=10e9;%��Ƶ
c=3e8;%����
t=10e-3;%��ɻ�����ʱ��
T=1/fm*1270;%��λ��������
N=15;%�����ظ�����(t/T)
snr=5;%Ŀ��ز���������ȣ�-35~10dB��
d=1000;%Ŀ�����(0~10000m)
v=2;%Ŀ���ٶȣ�0~1000m/s��
A=1;%Ŀ����ȣ�1~100��
m=1270;%һ�������ڵĲ��������
t1=2*d/c;%��ʱ
n1=fix(t1/5e-7);%��ʱ�������
%========================m���в���========================
connection=[1 0 0 0 0 0 1];
n=length(connection);
reg=[1 0 1 0 1 0 1 ];
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
m_1270=[m_bip zeros(1,1143)];%ռ�ձ�10%����
hb=repmat(m_1270,1,N);
pipei=fliplr(m_1270);%�����ش�ֱ�����ҷ�ת
hbb=conv(pipei,hb);
[maxa,adress]=max(hbb);
for i=1:5
y(i)=20*log10(hbb(i+adress-3));
end
x=1:1:5;
xi=1:1/360:5;
yi=interp1(x,y,xi,'cubic');%�ڲ庯��
figure;
plot(x,y,'o',xi,yi);
ylabel('���ȣ�dB��');
title('ʱ���ڲ庯��');
