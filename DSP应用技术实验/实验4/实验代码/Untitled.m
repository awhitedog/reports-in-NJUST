frequencyRange=k/T;
YfreqDomain=fft(y)/N;
cutOff = ceil(N/2);
YfreqDomain=YfreqDomain(1:cutOff);
frequencyRange = frequencyRange(1:cutOff);
figure(3)
 subplot(2,1,2)
plot(frequencyRange,abs(YfreqDomain),'LineWidth',1);
title('∆µ”Ú≤®–Œ')