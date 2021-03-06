%双目标仿真2   仿真出距离分辨和速度分辨的大小
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
snr=-10;%输入端信噪比

%大目标参数
Am_1=20;%目标幅度 范围1-100

%距离检测
v_1=200;%目标速度 范围0-1000
%destine_1=700;%目标距离 范围 0-10000
destine_1=700.1;

%速度检测
%destine_1=700;
%v_1=496;

%给定目标的速度和距离下N段信号
delay_1=2*destine_1/c;      %由距离产生回波信号延迟
delay_1=fix(delay_1*fe);
s_in_1=Am_1.*repmat(m_dline,1,N)./2;   %0延迟0多普率回波
s_in_1=[zeros(1,delay_1+1),s_in_1];  %加入延迟后的回波
s_in_1=awgn(s_in_1,snr,'measured'); %加入高斯噪声后的回波

fd_1=2*v_1*fg/c; %多普勒频移
for i=delay_1+1:N*p+delay_1+1;        
s_in_1(i)=s_in_1(i)*cos(2*pi*fd_1/fe*(i-1));  %加入多普勒频移后的回波信号
end
length_1=length(s_in_1);
%小目标参数
Am_2=20;%目标幅度 范围1-100

%距离检测
v_2=200;%目标速度 范围0-1000
%destine_2=710;%目标距离 范围 0-10000
destine_2=705;

%速度检测
%destine_2=700;
%v_2=500;



%给定目标的速度和距离下N段信号
delay_2=2*destine_2/c;      %由距离产生回波信号延迟
delay_2=fix(delay_2*fe);
s_in_2=Am_2.*repmat(m_dline,1,N)./2;   %0延迟0多普率回波
s_in_2=[zeros(1,delay_2+1),s_in_2];  %加入延迟后的回波
s_in_2=awgn(s_in_2,snr,'measured'); %加入高斯噪声后的回波

fd_2=2*v_2*fg/c; %多普勒频移
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
mesh(1:N,1:p,s_out_r_f);
% figure;
% plot(s_out_r_f(:,1))
title('双目标信号处理图像（距离分辨）');
%检测程序
delta_r=c/2/fe
p_max=max(max(s_out_r_f));
[x,y]=find(s_out_r_f>(p_max/1.05))


%title('双目标信号处理图像（速度分辨）');
%delta_v=fe*c/2/p/N/fg
%p_max=max(max(s_out_r_f));
%[x,y]=find(s_out_r_f>(p_max/1.05))