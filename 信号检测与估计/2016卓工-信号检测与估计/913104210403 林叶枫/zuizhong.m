close all;
clear all;
clc;
y=0;
T=2e-4;                          %ʱ��
B=3e6;                           %����
K=B/T;                           %��Ƶб��
Fs=B;Ts=1/Fs;  
N=T/Ts+1;                        %��������
t=0:Ts:T;
NUM=50;                          %��ɻ���������
St=exp(j*pi*K*t.^2);             %�����ź�
C=3e8;               %����
R=[5100,5100];       %����
V=[10,15];           %�ٶ�
A=[1,25];             %����
f0=10e9;             %��Ƶ 
lambda=C/f0;         %����
for i=1:2          %Ŀ����Ŀ
t0=floor(2*R(i)*Fs/C)+1;     %��ʱ�ĵ���
Sr=repmat(St,1,NUM);        %��ɻ���
sr=[Sr(NUM*N-t0+1:NUM*N) Sr(1:NUM*N-t0)].*A(i);      %��ʱ
%  for fd=0:100:3000;
 fd=2*V(i)/lambda ;              %������Ƶ��
t=0:Ts:(N*NUM-1)*Ts;
Sd=exp(2*j*pi*fd*t);            %�����������ź�
SR=sr.*Sd;                      %�ز��ź�
y=y+SR;
end
 SNR=-10;                        %�����
s=awgn(SR,SNR,'measured');      %��������
s1=s-y;                       %������
%%______________________��ѹ___________________________
h=fliplr(St) ;            %����ƥ���˲���
pipei=conv(conj(h),y);    %�Իز�����ƥ���˲�
 figure(3)
pipei_db=10*log10(abs(pipei.^2));
%%_____������������_______
n=abs(pipei.^2);
pn_maiya=10*log10(sum(n(:))/(N*50))%���е��Ӧ��������������ٳ����ܵ���
%% ______________________ 
% plot(pipei_db);
% title('��ѹ/db')
% axis on;grid on;
% figure(4)
% plot(abs(pipei));
% title('��ѹ(����)');
%%__________����߶�������յĹ�ϵ________
% figure(5)
% zhugaodu=10*log10(max(abs(pipei(:).^2)));  
% plot(fd,zhugaodu(),'o');
% hold on;
% axis([-inf,inf,10,90]);grid on;
% xlabel('������Ƶ��/Hz');
% ylabel('����߶�/db')
% title('����߶��������Ƶ�ʵĹ�ϵ')
% end
%%_______________________����_________________________
%%_______________________���������ź�fft______________
for r=1:50
    for h=1:N
        f_pipei(h,r)=pipei((r-1)*N+h);
    end
end
for h=1:N
    ff_pipei(h,:)=abs((fft(f_pipei(h,:))));
end

% % ____________�����������źŹ���__________
n=(ff_pipei).^2;
pn_fft=10*log10(sum(n(:))/(N*50))
ps_fft=10*log10((max( ff_pipei(:)).^2))
% %_______________________________________
figure(5)
v= (0:NUM-1).*0.5*lambda*1/T/NUM;  %�ٶ�
r=(0:N-1).*Ts*C/2;                 %����
mesh(v,r,20*log10(ff_pipei));
xlabel('�ٶ�');ylabel('����');zlabel('��ֵ')
%����5000���ٶ�10
% mesh(1:NUM,1:N,20*log10(y));
% x=6:1:10;
% z=20*log10(y(101,x));
% xi=6:0.01:10;
% zi=interp1(x,z,xi,'cublic');
% figure(6)
% plot(xi,zi);
% axis([-inf,inf,78,90]);grid on;
% set(gca,'ytick',[83.66,87.66],'Xtick',[7.274,8.417]);
% 
