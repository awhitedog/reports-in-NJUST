%双目标仿真1 大旁瓣掩盖小旁瓣
%仿真：1.仿真出大目标旁瓣覆盖小目标旁瓣的现象
%      2.仿真出距离分辨率和速度分辨率的大小

M_creater;%产生127点M序列m_dline

%回波参数
fe=21e6;%码频
p=127;%码元数
fg=10e9;%载频
t=10e-3;%相干累积最大时长
N=500;%相干累积长度
c=3e8;%光速
snr=30;%输入端信噪比

%大目标参数
Am_1=1;%目标幅度 范围1-100
v_1=45;%目标速度 范围0-1000
destine_1=715;%目标距离 范围 0-10000

%给定目标的速度和距离下N段信号
delay_1=2*destine_1/c;      %由距离产生回波信号延迟
delay_1=fix(delay_1*fe);
s_in_1=Am_1.*repmat(m_dline,1,N)./2;   %0延迟0多普率回波
s_in_1=[zeros(1,delay_1+1),s_in_1];  %加入延迟后的回波
s_in_1=awgn(s_in_1,snr,'measured'); %加入高斯噪声后的回波

fd_1=2*v_1*fg/c; %多普勒频移
%fd=fe/p/4;
for i=delay_1+1:N*p+delay_1+1;        
s_in_1(i)=s_in_1(i)*cos(2*pi*fd_1/fe*(i-1));  %加入多普勒频移后的回波信号
end
length_1=length(s_in_1);
%小目标参数
%Am_2=300;%目标幅度 范围1-100
Am_2=1;
v_2=40;%目标速度 范围0-1000
destine_2=715;%目标距离 范围 0-10000

%给定目标的速度和距离下N段信号
delay_2=2*destine_2/c;      %由距离产生回波信号延迟
delay_2=fix(delay_2*fe);
s_in_2=Am_2.*repmat(m_dline,1,N)./2;   %0延迟0多普率回波
s_in_2=[zeros(1,delay_2+1),s_in_2];  %加入延迟后的回波
s_in_2=awgn(s_in_2,snr,'measured'); %加入高斯噪声后的回波

fd_2=2*v_2*fg/c; %多普勒频移
%fd=fe/p/4;
for i=delay_2+1:N*p+delay_2+1;        
s_in_2(i)=s_in_2(i)*cos(2*pi*fd_2/fe*(i-1));  %加入多普勒频移后的回波信号
end
length_2=length(s_in_2);

%产生合信号
length_delta=length_1-length_2;
if (length_delta>0)
    s_in_2=[s_in_2,zeros(1,length_delta)];
    s_in=s_in_1+s_in_2;
else 
    s_in_1=[s_in_1,zeros(1,-length_delta)];
    s_in=s_in_1+s_in_2;
end

%脉压处理—匹配滤波器
ht=fliplr(m_dline);
s_out=conv(s_in,ht); %时域卷积完成匹配滤波

%距离门重排
for j=1:N
    for i=1:p
        s_out_r(i,j)=s_out((j-1)*p+i);
    end
end


%相干累加—FFT处理
for i=1:p
    s_out_r_f(i,:)=abs(fft(s_out_r(i,:)));
end

%绘制处理后图形
figure(1);
mesh(1:N,1:p,s_out_r_f)
title('双目标信号处理图像（未遮盖）');
%title('双目标信号处理图像（遮盖）');
