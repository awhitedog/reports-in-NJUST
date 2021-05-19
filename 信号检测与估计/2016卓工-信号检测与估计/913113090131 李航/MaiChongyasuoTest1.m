T=4e-3;%相参积累时间
Fm=31e6;%码元频率
Fc=10e9;%载波频率
N=floor(T*Fm/127);%相参积累周期数
t=0+1/Fc:1/Fm:126/Fm+1/Fc;%以码元频率采样
Sr1=PRFC(t);
Sr2=Receiver(30,40,1,-10);
Sr2=awgn(Sr2,-10,'measured');
% --------脉冲压缩------------%
H=fliplr(Sr1);
yasuo=conv(H,Sr2);
plot(abs(yasuo));
% --------------距离门重排-------------%
for r=1:N-1;
    for h=1:127;
        Rss(h,r)=yasuo(r*127+h);
    end
end
figure;
mesh(abs(Rss));
xlabel('多普勒频率');
ylabel('距离门数');
zlabel('幅度');
% figure;
% plot(abs(Rss(:,9)));
% xlabel('距离门数');
% ylabel('幅度');
% title('脉压后的波形');
%----------------插值---------------
% chazhii=abs(Rss(7:12,9));
% xi=linspace(7,12,1000);
% chazhio=interp1(7:12,chazhii,xi,'spline');
% plot(xi,20*log10(chazhio));
% xlabel('距离门数');
% ylabel('幅度/dB');
% title('插值后的脉压波形');
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
xlabel('多普勒频率');
ylabel('距离门数');
zlabel('幅度');
figure;
plot(R_FFT(9,:));
xlabel('多普勒采样点数');
ylabel('幅度');
title('距离门维的FFT信号');
%FFT插值
chazhi2i=R_FFT(9,5:12);
xi2=linspace(5,12,1000);
chazhi2o=interp1(5:12,chazhi2i,xi2,'spline');
figure;
plot(xi2,20*log10(chazhi2o));
xlabel('多普勒采样点数');
ylabel('幅度/dB');
title('多普勒维的插值');


