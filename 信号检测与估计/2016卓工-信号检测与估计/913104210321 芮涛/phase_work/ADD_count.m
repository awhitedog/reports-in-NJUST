% 计算脉压和FFT增益
function true=ADD_count(snr,fd,destine,m_dline,flag)

%回波参数
fe=21e6;%码频
p=127;%码元数
fg=10e9;%载频
t=10e-3;%相干累积最大时长
N=500;%相干累积长度
c=3e8;%光速

%目标参数
Am=20;%目标幅度 范围1-100

%不含噪声的纯信号
 delay=2*destine/c;      %由距离产生回波信号延迟
 delay=fix(delay*fe);
s_in_1=Am.*repmat(m_dline,1,N)./2; %0延迟0多普率回波
s_in_1=[zeros(1,delay+1),s_in_1];  %加入延迟后的回波
length_1=length(s_in_1);

for i=delay+1:N*p+delay+1;        
s_in_1(i)=s_in_1(i)*cos(2*pi*fd/fe*(i-1));  %加入多普勒频移后的回波信号
end

%脉压处理—匹配滤波器（带信号）
ht=fliplr(m_dline);
s_out_1=conv(s_in_1,ht); %时域卷积完成匹配滤波

%距离门重排
for j=1:N
    for i=1:p
        s_out_r_1(i,j)=s_out_1((j-1)*p+i);
    end
end
%相干累加
for i=1:p
    s_out_r_f_1(i,:)=abs(fft(s_out_r_1(i,:)));
end

%没有信号的纯噪声输入
s_in_2=awgn(s_in_1,snr,'measured'); %加入高斯噪声后的回波
s_in_2=s_in_2-s_in_1;%纯噪声信号

%脉压处理—匹配滤波器（不带信号）
ht=fliplr(m_dline);
s_out_2=conv(s_in_2,ht); %时域卷积完成匹配滤波

%距离门重排
for j=1:N
    for i=1:p
        s_out_r_2(i,j)=s_out_2((j-1)*p+i);
    end
end
%相干累加
for i=1:p
    s_out_r_f_2(i,:)=abs(fft(s_out_r_2(i,:)));
end

%计算脉压增益
enery_s_1=0;
for j=1:N
   p_max(j)=max(abs(s_out_r_1(:,j)));
   enery_s_1=enery_s_1+p_max(j)^2;
end
enery_s_1=enery_s_1/N;


enery_n_1=0;
for j=1:N
    for i=1:p
        enery_n_1=enery_n_1+ s_out_r_2(i,j)^2;
    end
end
enery_n_1=enery_n_1/N/p;%计算噪声功率
snr_out_1=10*log10(enery_s_1/enery_n_1);
snr_out_1_add=snr_out_1-snr

%计算FFT增益
if (flag==2)
p_max=max(max(abs(s_out_r_f_1)));%找到信号峰值点
[x,y]=find(s_out_r_f_1==p_max);
enery_s_2=0;
if (length(x)==1)
    enery_s_2=enery_s_2+s_out_r_f_1(x,y)^2;
    enery_s_2=enery_s_2;
else
for i=1:2
    enery_s_2=enery_s_2+s_out_r_f_1(x(i),y(i))^2;
end
    enery_s_2=enery_s_2/2;
end
enery_n_2=0;
for j=1:N
    for i=1:p
        enery_n_2=enery_n_2+ s_out_r_f_2(i,j)^2;
    end
end
enery_n_2=enery_n_2/N/p;%计算噪声功率
snr_out_2=10*log10(enery_s_2/enery_n_2);%计算脉压输出端信噪比
snr_out_2_add=snr_out_2-snr_out_1
end
true=1;
