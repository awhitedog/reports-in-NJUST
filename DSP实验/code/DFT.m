clear all;
N=256;dt=0.02;
n=0:N-1;t=n*dt;
x=sin(2*pi*t);
m=N;
a=zeros(1,m);b=zeros(1,m);
for k=0:m-1
    for ii=0:N-1
        a(k+1)=a(k+1)+2/N*x(ii+1)*cos(2*pi*k*ii/N);
        b(k+1)=b(k+1)+2/N*x(ii+1)*sin(2*pi*k*ii/N);
    end
c(k+1)=sqrt(a(k+1)^2+b(k+1)^2);
end
subplot(211);plot(t,x);title('ԭʼ�ź�'),xlabel('ʱ��/t');
f=(0:m-1)/(N*dt);
subplot(212);plot(f,c);hold on
title('Fourier');xlabel('Ƶ��/HZ');ylabel('���');
ind=find(c==max(c),1,'first');%Ѱ�����ֵ��λ��
%%%%%%% ind = find(X, k) ��ind = find(X, k, 'first')
%   ���ص�һ������Ԫ��k������ֵ��˳�򣩡�
%   k������һ���������������������κ�������ֵ���͡�

x0=f(ind); %����λ�õõ������꣨Ƶ�ʣ�
y0=c(ind); %����λ�õõ������꣨���ȣ�
plot(x0,y0,'ro');hold off

%%%%%%% hold on ��hold off�������ʹ�õ�.ͨ����һ��ͼ�ϻ��������߽��бȽϡ�
%   ǰ�ߵ���˼�ǣ����ڵ�ǰͼ���ᣨ����ϵ���л���һ��ͼ���ٻ���һ��ͼʱ��ԭ����ͼ���ڣ�����ͼ���棬�����õ�
%   ���߱����ǣ����ڵ�ǰͼ���ᣨ����ϵ���л���һ��ͼ����ʱ��״̬��hold off,���ٻ���һ��ͼʱ��ԭ����ͼ�Ϳ������ˣ������ϻ��Ƶ�����ͼ��ԭͼ���滻��

text(x0+1,y0-0.1,num2str(x0,'Ƶ��=%f'));

%   text(x,y,'string')��ͼ����ָ����λ��(x,y)����ʾ�ַ���string