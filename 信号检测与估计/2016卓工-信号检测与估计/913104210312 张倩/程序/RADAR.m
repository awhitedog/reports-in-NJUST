clear all;
close all;
clc;
fm=12e6;%��Ƶ
fc=10e9;%��Ƶ
t=10e-3;%��ɻ�����ʱ��
T=1/fm*1270;%����
N=94;%��ɻ��۴���
snr=10;%�����
m=1270;
c=3e8;
v=[5,40];
R=[5000,5000];
fudu=[2,20];
hb12=0;
m_127=m_sequence([1 0 0 0 0 0 1]);%m����
for p=1:1;
 mbip_127=fudu(p)*m_127-fudu(p)/2;%˫����m����;
mt=[mbip_127 zeros(1,1143)];%ռ�ձ�10%��m����
 mr=repmat(mt,1,N);
yanchi=round(2*R(p)*fm/c);
mr=[mr(1270*N-yanchi+1:1270*N) mr(1:1270*N-yanchi)];
mr1=[mt zeros(1,1270)];
mr2=repmat(mt,1,N-2);
% mr0=[mr1 mr2];
% yanchi=round(2*R(p)*fm/c);
% mr=[mr0(1270*N-yanchi+1:1270*N) mr0(1:1270*N-yanchi)];
% hb1=mr;%������ʱ��0�������ʵĻز�
fd=doppler_freq(fc,0,v(p),1);%������Ƶ��%
 for i=1:1270*N;  
   doppler(i)=exp(j*2*pi*fd/fm*i);  
 end
hb2=mr.*doppler;%�Ӷ�����Ƶ�ƺ�Ļز�
hb12=hb12+hb2;
end
hb12wuzao=hb12;
%hb12=awgn(hb12,snr,'measured');
zaosheng=hb12-hb12wuzao;
%��ѹ�������ź�
pipei=fliplr(mt);
hbb2=conv(pipei,hb12);
m_hb1=abs(hbb2);
m_hb=abs(hbb2)/max(m_hb1);
m_hb=10*log10(m_hb);
%��ѹ�������������ź�
hbb2wuzao=conv(pipei,hb12wuzao);
zaoshengmaiya=conv(pipei,zaosheng);
%��ѹ����ȼ���
mas=max(abs(hbb2wuzao));
ps_m=10*log10(mas*mas);
zaoshengmaiyapf=abs(zaoshengmaiya.*zaoshengmaiya);
pn_m=10*log10(sum(zaoshengmaiyapf(:))/120649);
snr_m=ps_m-pn_m;
snr_m_d=ps_m-pn_m-snr;

%����������
for r=1:N;
    for h=1:m;
        s_hb2(h,r)=hbb2((r-1)*m+h);
        s_hb2wuzao(h,r)=hbb2wuzao((r-1)*m+h);
        s_zaosheng(h,r)=zaoshengmaiya((r-1)*m+h);
    end
end
%fft
for h=1:m
    r_fft2(h,:)=abs(fft(s_hb2(h,:)));
    r_fft2wuzao(h,:)=abs(fft(s_hb2wuzao(h,:)));
    r_fft2zaosheng(h,:)=abs(fft(s_zaosheng(h,:)));
end
%fft����ȼ���
ps_fft=10*log10(max(max(r_fft2wuzao))*max(max(r_fft2wuzao)));
pn_fft=(r_fft2zaosheng).*(r_fft2zaosheng);
pn_fft=10*log10(sum(pn_fft(:))/1270/N);
snr_fft=ps_fft-pn_fft;
snr_fft_d=ps_fft-pn_fft-snr_m;

subplot(2,2,1);plot(1:N*1270,mr);
title('�����ź�')

subplot(2,2,2);plot(abs(hbb2));
title('�ز��ź���ѹ���')
xlabel('��������');ylabel('����');


% set(gca,'Ytick',[3993,7986],'Xtick',[26.24,28.83]);
% title('�ڲ�˵����ѹ��ʱ��');
% xlabel('�ٶ�');ylabel('����');
% 

subplot(2,2,3);plot(abs(hbb2));
title('�ز��ź���ѹ���')
axis([1260 1280 -10 140]);grid on;
set(gca,'Ytick',[67.5,127],'Xtick',[1269.5,1270.5]);

subplot(2,2,4);plot(m_hb);
title('�ز��ź���ѹ��һ��db���')
xlabel('��������');ylabel('����/db');

%figure(5);mesh(1:N,1:1270, s_hb2);
figure(6);mesh(1:N,1:1270,r_fft2);
% figure(6);mesh(1:N,1:1270,20*log10(r_fft2));
xlabel('�ٶ�');ylabel('����');zlabel('����');
figure(7);mesh(0:fm*0.03/1270/94/2:(N-1)*fm*0.03/1270/94/2,c/2/fm:c/2/fm:c/2/fm*1270,r_fft2);
xlabel('�ٶ� m/s');ylabel('����/m');zlabel('����');
 

% figure(9);plot(1:N*1270,mr0,'g',1:N*1270,mr,'r');
% title('����ģ��ֵm')

acmbip_127=xcorr(mbip_127);
figure(10);plot(acmbip_127);%˵��m������ѹ�������
axis([100 150 -10 140]);grid on;
set(gca,'Ytick',[67.5,127],'Xtick',[126.5,127.5]);
title('˫����m���е���ѹ���')

x=3:1:5;
y=r_fft2(400,x);
xi=3:0.01:5;
yi=interp1(x,y,xi,'cublic');
figure(11);plot(xi,yi);
grid on;
% set(gca,'Ytick',[3993,7986],'Xtick',[26.24,28.83]);
title('�ڲ�˵��FFT�Ĵ���');
xlabel('�ٶ�');ylabel('����');

x1=1269:1:1271;
y1=[-1,127,-1];
x2=1269:0.01:1271;
y2=interp1(x1,y1,x2,'linear');

figure(12);plot(x2,y2);
set(gca,'Ytick',63.5);
grid on;