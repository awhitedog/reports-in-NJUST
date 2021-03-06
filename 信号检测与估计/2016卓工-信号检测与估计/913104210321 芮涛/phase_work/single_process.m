%单目标信号处理仿真验证时宽带宽
M_creater;%产生127点M序列m_dline

%回波参数
fe=21e6;%码频
p=127;%码元数
fg=10e9;%载频
t=10e-3;%相干累积最大时长
N=500;%相干累积长度
c=3e8;%光速
snr=-5;%输入端信噪比

%目标参数
Am=20;%目标幅度 范围1-100
%v=0;
v=5;
%v=100;%目标速度 范围0-1000
destine=200;%目标距离 范围 0-10000

%给定目标的速度和距离下N段信号
delay=2*destine/c;      %由距离产生回波信号延迟
delay=fix(delay*fe);
s_in=Am.*repmat(m_dline,1,N)./2;   %0延迟0多普率回波
s_in=[zeros(1,delay+1),s_in];  %加入延迟后的回波
s_in=awgn(s_in,snr,'measured'); %加入高斯噪声后的回波

fd=2*v*fg/c; %多普勒频移
for i=delay+1:N*p+delay+1;        
s_in(i)=s_in(i)*cos(2*pi*fd/fe*(i-1));  %加入多普勒频移后的回波信号
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

%求脉压时宽插值

k=100;
y=0;
x=1:k+3;
for j=1:N
    a_line=(abs(s_out_r(:,j)))';
    a_max=max(a_line);
    a_label=find(a_line==a_max);
    a_label=[a_label-1,a_label,a_label+1];
    y=y+a_line(a_label);  
end
    y=y/N;
    yi=inter_edit(y,k);
    yi_db=20*log10(yi);
    figure(3);
    plot(x,yi_db)
    title('脉压处理时宽插值曲线');
    xlabel('插值点n');
    ylabel('插值曲线/dB');
 %相干累加—FFT处理
 for i=1:p
     s_out_r_f(i,:)=abs(fft(s_out_r(i,:)));
 end
 
 %求相干累加时宽带宽
k=100;
p_max=max(max(abs(s_out_r_f)));
[x,y]=find(s_out_r_f==p_max);
f_array=abs((s_out_r_f(:,y(1)))');%求时宽
f_line=abs(s_out_r_f(x(1),:));%求带宽
yi_t=f_array([x(1)-1,x(1),x(1)+1]);
yi=inter_edit(yi_t,k);
figure(4);
yi=20*log10(yi);
x=1:k+3;
plot(x,yi)
title('FFT处理后时宽');
xlabel('插值点n');
ylabel('插值线/dB');

yi_t=f_line([y(1)-1,y(1),y(1)+1]);
yi=inter_edit(yi_t,k);
figure(5);
yi=20*log10(yi);
x=1:k+3;
plot(x,yi)
title('FFT处理后带宽');
xlabel('插值点n');
ylabel('插值线/dB');


p_max=max(max(s_out_r_f));
[x,y]=find(s_out_r_f==(p_max))


%计算脉压和FFT增益比
true=ADD_count(snr,fd,destine,m_dline,2)

%绘制脉压后图像
figure(1);
mesh(1:N,1:p,s_out_r)
title('脉压处理后输出（带多普勒频移即延时）');


%绘制相干累积后图形
figure(2);
mesh(1:N,1:p,s_out_r_f)
title('相干积累后输出（带多普勒频移和延时');

