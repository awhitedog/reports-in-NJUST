%绘制性能损失曲线
clear all;
M_creater;
%回波参数
Am=20;
fe=21e6;
p=127;
snr=-10;
N=500;

%绘制性能损失曲线
for k=1:11
%0延迟多普勒回波信号
s_in=repmat(m_dline,1,N);  %0延迟0多普率回波
%s_in=awgn(s_in,snr,'measured');%加入高斯噪声后的回波
fd=(k-1)/10*fe/p;
i=0:p*N-1;
s_in=s_in.*cos(2*pi*fd/fe*i);  %加入多普勒频移后的回波信号

%脉压处理—匹配滤波器
ht=fliplr(m_dline);
s_out=conv(s_in,ht); %时域卷积完成匹配滤波
%距离门重排
for j=1:N
    for i=1:p
        s_out_r(i,j)=s_out((j-1)*p+i);
    end
end
for j=1:N
    a_line=(s_out_r(:,j))';
    a_line=abs(a_line);
    t_max=max(a_line);
    a_label=find(a_line==t_max);
    a_line(a_label)=[];
    p_max=max(a_line);
    d_p(j)=t_max/p_max;
   
end
    s_p(k)=sum(d_p)/N;
end
s_p=20*log10(s_p);
k=0:10;
plot(k,s_p)
title('多普勒频移导致的脉压损失曲线');
xlabel('x10e-1码元频率');
ylabel('主旁瓣比/dB');

