T=4e-3;%��λ���ʱ��
Fm=31e6;%��ԪƵ��
Fc=10e9;%�ز�Ƶ��
N=floor(T*Fm/127);%��λ���������
t=0+1/Fc:1/Fm:126/Fm+1/Fc;%����ԪƵ�ʲ���
Sr1=PRFC(t);
Sr2=Receiver(30,40,1,-10);
Sr2=awgn(Sr2,-10,'measured');
% --------����ѹ��------------%
H=fliplr(Sr1);
yasuo=conv(H,Sr2);
plot(abs(yasuo));
% --------------����������-------------%
for r=1:N-1;
    for h=1:127;
        Rss(h,r)=yasuo(r*127+h);
    end
end
figure;
mesh(abs(Rss));
xlabel('������Ƶ��');
ylabel('��������');
zlabel('����');
% figure;
% plot(abs(Rss(:,9)));
% xlabel('��������');
% ylabel('����');
% title('��ѹ��Ĳ���');
%----------------��ֵ---------------
% chazhii=abs(Rss(7:12,9));
% xi=linspace(7,12,1000);
% chazhio=interp1(7:12,chazhii,xi,'spline');
% plot(xi,20*log10(chazhio));
% xlabel('��������');
% ylabel('����/dB');
% title('��ֵ�����ѹ����');
% subplot(2,2,2);
% plot(abs(Rss(:,462)));
% subplot(2,2,3);
% plot(abs(Rss(:,636)));
% -------------------FFT-----------------------%
for i=1:127
    R_FFT(i,:)=abs(fft(Rss(i,:)));
end
figure;
mesh(R_FFT);
xlabel('������Ƶ��');
ylabel('��������');
zlabel('����');
figure;
plot(R_FFT(9,:));
xlabel('�����ղ�������');
ylabel('����');
title('������ά��FFT�ź�');
%FFT��ֵ
chazhi2i=R_FFT(9,5:12);
xi2=linspace(5,12,1000);
chazhi2o=interp1(5:12,chazhi2i,xi2,'spline');
figure;
plot(xi2,20*log10(chazhi2o));
xlabel('�����ղ�������');
ylabel('����/dB');
title('������ά�Ĳ�ֵ');


