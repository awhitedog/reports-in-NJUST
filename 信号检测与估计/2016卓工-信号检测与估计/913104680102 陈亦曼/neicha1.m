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
%=======================��Ŀ��======================
pipei=fliplr(m_bip);%�����ش�ֱ�����ҷ�ת
hbb=conv(pipei,m_bip);
m_1270=[m_bip zeros(1,1143)];%ռ�ձ�10%����
hb=repmat(m_1270,1,N);
clear j;
%---------------------�ز�--------------------------------------
hb=[zeros(1,n1) hb(1:1270*N-n1)]*A;%����ʱ
fd=2*v/(c/fc);
duopule=exp(j*2*pi.*(1:1:1270*N)*fd/fm);
hb1=hb.*duopule;%�Ӷ�����
hb2=awgn(hb1,snr,'measured');%������
% subplot(3,1,1);plot(real(hb));
% subplot(3,1,2);plot(real(hb1));
% subplot(3,1,3);plot(real(hb2));title('�ܶ�����Ƶ�ʵ��ƵĻز�');
figure;plot(real(hb2));title('�ܶ�����Ƶ�ʵ��ƵĻز�');
%xlabel('t/\mus'),ylabel('hb2(t)')
%---------------------��ѹ-------------------------------------
pipei=fliplr(m_1270);
hbb1=conv(pipei,hb1);
% m_hb1=abs(hbb1);
% m_hb=abs(hbb1)/max(m_hb1);
% m_hb=10*log10(m_hb);
% figure;plot(m_hb);
hbb2=hbb1(1:2000);
figure;plot(real(hbb2));
title('��ѹ��һ�����ڵ����ͼ��');
axis([1250 1300 -20 140]);grid on;
set(gca,'Ytick',[67.5,127],'Xtick',1270);
%---------------------��ѹ����߶�������յ�����------------------------%
fd1=0:1000:14000;h=1:1:15;
for i=1:15
duopule1=exp(j*2*pi.*(1:1:1270)*fd1(i)/fm);
hb3=m_1270.*duopule1;
pipei=fliplr(m_1270);
hbb3=conv(pipei,hb3);
h(i)=max(10*log10(abs(hbb3)));
%h(i)=max(abs(hbb3));
end
figure;plot(fd1*1e-3,h);
title('��ѹ����߶�������յ�����');
xlabel('������Ƶ��/KHz');ylabel('��ѹ����߶�/dB');
grid on;
set(gca,'Ytick',[17.1,21.04]);
hbb4=conv(pipei,hb2);
%--------����������---------------%
for r=1:N
for h=1:m
s_hb2(h,r)=hbb4((r-1)*m+h);
end
end
figure;mesh(1:N,1:m,real(s_hb2));
%figure;mesh(1:N,linspace(0,95250,1270),real(s_hb2));
title('��ѹ�����ͼ��');
xlabel('x/����������');ylabel('y/Ŀ�����');zlabel('z/Ŀ�����');
%---------------------------------
for h=1:m
r_fft2(h,:)=abs(fft(s_hb2(h,:)));
end
%figure;mesh(1:N,linspace(0,95250,1270),10*log10(real(r_fft2)));
figure;mesh(1:N,1:1270,real(r_fft2));
title('FFT�����ͼ��');
xlabel('x/Ŀ���ٶ�');ylabel('y/Ŀ�����');zlabel('z/Ŀ�����');
%-----------FFT��ʱ��ʹ���
%��ʱ��
for i=1:m
for j=1:N
m_hb1(N*(i-1)+j)=r_fft2(i,j);
end
end           %��FFT��ľ���ת��Ϊһά����
[max0,adress]=max(m_hb1);%ȡ�����ֵ��λ��
for i=(adress-2):(adress+2);
y0(i-(adress-3))=m_hb1(i);
y(i-(adress-3))=20*log10(y0(i-(adress-3)));
end
x=1:1:5;
xi=1:1/360:5;
yi=interp1(x,y,xi,'cubic');%�ڲ庯��
figure;
plot(x,y,'o',xi,yi);
ylabel('���ȣ�dB��');
title('ʱ���ڲ庯��');
%�����
for i=1:N
for j=1:m
m_hb1(m*(i-1)+j)=r_fft2(j,i);
end
end           %��FFT��ľ���ת��Ϊһά����
[max0,adress]=max(m_hb1);%ȡ�����ֵ��λ��
for i=(adress-1):(adress+1);
y0(i-(adress-2))=m_hb1(i);
y1(i-(adress-2))=20*log10(y0(i-(adress-2)));
end
x1=1:1:3;
xi1=1:1/360:3;
yi1=interp1(x1,y1,xi1,'cubic');%�ڲ庯��
figure;
plot(x1,y1,'o',xi1,yi1);
ylabel('���ȣ�dB��');
title('�����ڲ庯��');