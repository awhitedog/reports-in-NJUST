%仿真单目标时脉压处理对多普勒频移的敏感关系，在仿真中不考虑延迟的问题（匹配滤波器对时延自适应）
%包括：1.多普勒敏感现象，在这里取无多普勒（fd=0），小多普勒（fd=1/4个发射波周期），多普勒容限时（fd=发射波周期）
%       2.绘制性能损失曲线（脉压主旁瓣与多普勒频移关系曲线）
%单目标信号处理仿真
M_creater;%产生127点M序列m_dline

%回波参数
fe=21e6;%码频
p=127;%码元数
fg=10e9;%载频
t=10e-3;%相干累积最大时长
N=500;%相干累积长度
c=3e8;%光速
snr=-5;%输入端信噪比

Am=20;%回波幅度
destine=0;

%0延迟多普勒回波信号
s_in=repmat(m_dline,1,N);   %0延迟0多普率回波
s_in=Am/2.*awgn(s_in,snr,'measured'); %加入高斯噪声后的回波

%fd=0; %多普勒频移1
%fd=fe/p/4;%多普勒频移2
fd=fe/p/2;
%fd=fe/p;%多普勒频移3；

i=1:p*N;
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

true=ADD_count(snr,fd,destine,m_dline,1)

%绘制脉压后图像
figure(1);
mesh(1:N,1:p,s_out_r)
title('脉压处理后输出');


