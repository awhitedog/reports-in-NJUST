clc,clear;
T=4e-3;
Fm=31e6; %码元的频率,快采样频率
Fc=10e9;%相干积累时间
t=1/Fc:1/Fm:126/Fm+1/Fc; %对一个周期内的样本进行快采样T=4e-3;
snr=-10; %输入信噪比
c=3e8;  %电磁波传播的速度
Fs=Fm/127; %慢采样频率
Fd=5.794e4;
Vr=(Fd*0.03)/2;
N=floor(T*Fm/127); %计算相干积累的周期数
H=fliplr(PRFC(t));    %计算匹配滤波器的冲激响应
Sre1=Receiver(0,30,1,snr); %得到在R0处 速度为Vr的回波信号(无多普勒）
Sre2=Receiver(1000,30,1,snr); %(有多普勒）
%------------------------匹配滤波（脉冲压缩）-----------------------%
yasuo1=conv(H,Sre1);
yasuo2=conv(H,Sre2);
%--------------距离门重排-------------%
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
% xlabel('距离门数');
% ylabel('幅度');
% subplot(2,2,2);
% plot(R2_FFT(a,:));
% xlabel('多普勒采样点数');
% ylabel('幅度');
% title('具有fd=10kHz多普勒的脉压信号');
% [c,d]=find(R1_FFT==max(max(R1_FFT)))
% subplot(2,1,2)
% plot(R1_FFT(:,d));
% xlabel('距离门数');
% ylabel('幅度');
% title('不含多普勒的脉压信号');
%画主瓣衰减曲线
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
xlabel('多普勒频率Hz');
ylabel('主旁瓣比/dB');
title('损失曲线')


