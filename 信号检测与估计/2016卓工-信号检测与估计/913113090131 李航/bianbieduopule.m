clc,clear;
T=4e-3; %相干积累时间
snr=-10; %输入信噪比
c=3e8;  %电磁波传播的速度
R=500; %目标距离雷达的距离
Fm=31e6; %码元的频率,快采样频率
Fc=10e9; %载波频率
N=floor(T*Fm/127); %计算相干积累的周期数
t=linspace(0,127/Fm,127);
H=fliplr(PRFC(t));
Sr2=Receiver(500,300,1,-1)+Receiver(505,300,1,-1); %两个目标的回波
yasuo=conv(H,Sr2);   %匹配滤波
%--------------距离门重排-------------%
for r=1:N;
    for h=1:127;
        Rss(h,r)=yasuo((r-1)*127+h);
    end
end
%-------------------FFT-----------------------%
for i=1:127
    R_FFT(i,:)=abs(fft(Rss(i,:)));
end
figure;
mesh(1:N,1:127,R_FFT); %大目标旁瓣掩盖小目标
xlabel('多普勒采样点数/相参积累的周期数');
ylabel('距离门数');
zlabel('幅度');
title('大目标和小目标共存');

