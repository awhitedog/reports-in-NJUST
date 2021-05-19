clc,clear;
T=4e-3;
Fm=31e6; %��Ԫ��Ƶ��,�����Ƶ��
Fc=10e9;%��ɻ���ʱ��
t=1/Fc:1/Fm:126/Fm+1/Fc; %��һ�������ڵ��������п����T=4e-3;
snr=-10; %���������
c=3e8;  %��Ų��������ٶ�
Fs=Fm/127; %������Ƶ��
Fd=5.794e4;
Vr=(Fd*0.03)/2;
N=floor(T*Fm/127); %������ɻ��۵�������
H=fliplr(PRFC(t));    %����ƥ���˲����ĳ弤��Ӧ
Sre1=Receiver(0,30,1,snr); %�õ���R0�� �ٶ�ΪVr�Ļز��ź�(�޶����գ�
Sre2=Receiver(1000,30,1,snr); %(�ж����գ�
%------------------------ƥ���˲�������ѹ����-----------------------%
yasuo1=conv(H,Sre1);
yasuo2=conv(H,Sre2);
%--------------����������-------------%
for r=1:N-1;
    for h=1:127;
        Rss1(h,r)=yasuo1((r)*127+h);
        Rss2(h,r)=yasuo2((r)*127+h);
    end
end
%-------------------FFT-----------------------%
for i=1:127
    R1_FFT(i,:)=abs(fft(Rss1(i,:)));
    R2_FFT(i,:)=abs(fft(Rss2(i,:)));
end
% figure;
% subplot(2,1,1)
% [a,b]=find(R2_FFT==max(max(R2_FFT)));
% plot(R2_FFT(:,b));
% xlabel('��������');
% ylabel('����');
% subplot(2,2,2);
% plot(R2_FFT(a,:));
% xlabel('�����ղ�������');
% ylabel('����');
% title('����fd=10kHz�����յ���ѹ�ź�');
% [c,d]=find(R1_FFT==max(max(R1_FFT)))
% subplot(2,1,2)
% plot(R1_FFT(:,d));
% xlabel('��������');
% ylabel('����');
% title('���������յ���ѹ�ź�');
%������˥������
FD=linspace(0,1.6123e+04,1000);
VB=(FD*0.03)/2;
for i=1:1000
    SR=Receiver(VB(i),30,1,snr);
    yasuo3=conv(H,SR);
    for r=1:N-1
        for h=1:127
            RSS(h,r)=yasuo3(r*127+h);
        end
    end
    for j=1:127
        RSS_FFT(j,:)=abs(fft(RSS(j,:)));
    end
    OUT(i)=max(max(RSS_FFT));
    [e,f]=find(RSS_FFT==max(max(RSS_FFT)));
    X=RSS_FFT(:,f);
    X(e)=0;
    OUT1(i)=OUT(i)/max(X);
end
figure;
plot(FD,20*log10(OUT1));
xlabel('������Ƶ��Hz');
ylabel('���԰��/dB');
title('��ʧ����')


