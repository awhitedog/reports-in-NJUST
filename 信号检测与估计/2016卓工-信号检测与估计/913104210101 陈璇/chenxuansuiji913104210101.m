%----------------------------信号检测与估计作业-----------------------------%
%-----------------------仿真伪随机相位编码连续波雷达的信号处理---------------%
%-----------------------------913104210101--------------------------------%
%---------------------------------陈璇------------------------------------%
%-----------------------------指导老师：顾红-------------------------------%

close all;
clear;                 
clc;                  

%% --------------------------参数设定--------------------------- %%
n=7;                                                                       %级数
fm=1e6;                                                                    %码频为学号末两位（01），码频为1MHz
mc=2^n-1;                                                                  %码长为127
fc=10e9;                                                                   %雷达载频为10GHz    
snr=-15;                                                                   %目标回波输入信噪比（-35dB～10dB）
V1=0;                                                                      %目标1速度可变（0～1000m/s）
V2=0;                                                                      %目标2速度可变（0～1000m/s） 
c=3e8;                                                                     %光速
A0=1;                                                                      %发射信号的幅度
A1=10;                                                                     %目标1的幅度可变（1～100）
A2=80;                                                                     %目标2的幅度可变（1～100）
D1=2000;                                                                   %目标1的距离可变（0～10000m）
D2=1500;                                                                   %目标2的距离可变（0～10000m）
tr1=2*D1/c;                                                                %雷达波从目标1回波的延时
tr2=2*D2/c;                                                                %雷达波从目标2回波的延时
fd1=2*V1*fc/c;                                                             %目标1的多普勒频偏
fd2=2*V2*fc/c;                                                             %目标2的多普勒频偏
txg=10e-3;                                                                 %相干积累总时宽 
N=78;                                                                      %积累时间不大于10ms，N<t/T=78.74,所以N取78 T=1/fm*127;
dfenbian=c/2/fm;                                                           %距离分辨力，此处计算结果为150  
fdrx=1/2/mc*fm;                                                            %多普勒容限,此处为3937hz,对应速度60m/s
Rmax=N/fm*c/2;                                                             %最大作用距离
vfebian=1*fm*c/fc/2/mc/N;                                                  %速度分辨力为1.5142m/s


%% -------------------------- m序列产生------------------------- %%
m_127=zeros(1,2^n-1);                                                      %m序列初始化
choutou= [fix(n/2)+1,n];                                                   %定义反馈级联的抽头位置,fix截尾取整
xishu(choutou) = 1;                                                        %令反馈级联抽头所在处为一
xishu=xishu';                                                              %对系数转置
register=[0,1,0,1,0,1,0];                                                  %定义寄存器初始状态，不能全为零
for i=1:2^n-1                           
    m_127(1,i) =1- 2*register(n);                                          % 输出第一个点（十进制）  
    weishu = mod(register*xishu,2);                                        % 模2运算
    register(2:n) = register(1:n-1);                                       % 第二位到最后一位移位运算
    register(1)=weishu;                                                    % 模二的结果赋给第一位
end

%% ---------------------------m序列自相关----------------------- %%
msequence=repmat(m_127,1,N);                                               %对生成的127位m序列进行周期延拓
a = msequence(1:end) ;                                                     %生成矩阵空间
b = m_127 ;                       
c = zeros(500,1) ;
for i = 1:500
    c(i) = b*a(i:i+126)' ;
end
figure(1),plot(c/127);
title('m序列自相关');

%% --------------------------发射信号--------------------------- %%
fc1=2e6;                                                                   %为了画图的方便，此处将载频设为2MHz
Fs=8e6;                                                                    %采样频率为8MHz                 
mf=repmat(m_127,1,1);
mf=mf(1:4);
T=length(mf)*10e-6;
B=[];
for i=1:4
    if mf(i)==1
        BB=ones(1,80);
        B=[B,BB];
    else
        BB=-1*ones(1,80);
        B=[B,BB];
    end
end

Ts=1/Fs;                                                                   %抽样间隔
nn=T/Ts;                                                                   %时间序列长度  
t=linspace(0,T,nn);
i=1:320;
f=cos(2*pi*fc*t);
sf=A0*B.*sin(2*pi*fc*t);
figure(8),subplot(3,1,1),plot(i,B);
subplot(3,1,2),plot(t,f);
subplot(3,1,3),plot(t,sf);

%% *************************单目标****************************** %%

%% -------------------------回波信号---------------------------- %%
n_delay1=fix(tr1*fm);                                                      %延迟的码元个数,tr1为雷达波从目标1回波的延时，fm为码频
m_delay1=zeros(1,mc);                                                      %m_delay为回波的单周期m序列，生成矩阵空间
m_delay1(1:n_delay1)=m_127(mc-n_delay1+1:mc);                              %前几个是原m序列的后几个
m_delay1(n_delay1+1:mc)=m_127(1:mc-n_delay1);                              %后几个是原m序列的前几个
mr1=repmat(m_delay1,1,N);                                                  %解调后m序列，延迟n_delay个码元，包含了目标距离信息
j1=1:mc*N;                                                                 %自变量                                                              
sr1=A1*mr1.*cos(2*pi*fd1*j1/fm);                                           %目标1的回波信号                                          
sr1_snr=awgn(sr1,snr,'measured');                                          %信噪比为snr,awgn指加性高斯白噪声
j11=1:mc; 
sr11=A1*m_delay1.*cos(2*pi*fd1*j11/fm);  
sr11_snr=awgn(sr11,snr,'measured');
P_signal=A1*A1;
noise=sr1_snr-sr1;
E_noise=0;
for i=1:mc*N
    E_noise=E_noise+noise(i)*noise(i);
end
P_noise=E_noise/(mc*N)                                                     %平均噪声功率
SNR1=10*log10(P_signal/P_noise)                                            %信道噪声验证
%figure(9),plot(j1,sr1);

%% -------------------------脉压------------------------------- %%
k1=fliplr(m_127);                                  
my1=conv(sr1_snr,k1);                                                      %脉冲压缩处理
signal=conv(sr1,k1);
noise=my1-signal;
E_signal=0;
for i=1:mc*N+126
    E_signal=E_signal+signal(i)*signal(i);
end
P_signal=E_signal/(mc*N+126)
% E_noise=0;
% for i=1:mc*N+126
%     E_noise=E_noise+noise(i)*noise(i);
% end
% P_noise=E_noise/(mc*N+126) 
SNR2=10*log10(P_signal/P_noise)
my11=conv(sr11_snr,k1);
%my11=20*log10(my1);
figure(2),subplot(2,1,1),plot(abs(my1));                                   %绘制脉压后的波形  
title('单目标多周期脉冲压缩后的波形');
subplot(2,1,2),plot(abs(my11))
title('单目标单周期脉冲压缩后的波形');

[maxa,quwei]=max(my1);                                                     %求时宽
for i=1:5
    y(i)=20*log10(my1(i+quwei-3));
end
x=1:5                                                                     
xi=1:1/360:5;
yi=interp1(x,y,xi,'cubic');                                                %用内插函数
figure(9),plot(x,y,'o',xi,yi);                                             %图9显示时宽
title('时宽');
%% ----------------------- -FFT-------------------------------- %%
for r=1:N    
    for h=1:mc        
        cp1(h,r)=my1((r-1)*mc+h);     
    end
end
cp1=cp1';
cp1=[cp1,zeros(78,1)];
cp1=cp1';
%figure(3),mesh(1:N,1:mc+1,cp1);                                           %距离门重排
%title('单目标FFT波形')
for h=1:mc+1
    r_fft1(h,:)=abs(fft(cp1(h,:))); 
end
figure(3),mesh(1:N,1:mc+1,r_fft1);                                         %按距离门进行FFT输出
title('单目标FFT波形')
                                                                           %求带宽
for i=1:78                                                                
for j=1:128
m_hb1(128*(i-1)+j)=r_fft1(j,i);
end
end                                                                        %FFT后的二维转换为一维
[max0,quwei]=max(m_hb1);                                                  %求最大值的位置
for i=(quwei-1):(quwei+1);
y0(i-(quwei-2))=m_hb1(i);
y1(i-(quwei-2))=20*log10(y0(i-(quwei-2)));                                 
end
x1=1:1:3;
xi1=1:1/360:3;
yi1=interp1(x1,y1,xi1,'cubic');                                            %用内插函数法计算
figure(10);
plot(x1,y1,'o',xi1,yi1);                         
ylabel('幅度（dB）');
title('带宽');

figure(4);
v=0;
for i=0:1:60
    v=v+1;
    fd=2*v*fc/(3e8);              
    mr=repmat(m_delay1,1,N);
    j=1:mc*N;
    y=cos(2*pi*fd/fm*j);
    sr=A1*mr.*y;
    sr_snr=awgn(sr,snr,'measured');
    my=conv(sr_snr,k1);  
 for r=1:N    
    for h=1:mc        
        cp1(h,r)=my((r-1)*mc+h);     
    end
 end
cp11=cp1';
cp11=[cp11,zeros(78,1)];
cp11=cp11';
 for h=1:mc+1
    r_fft1(h,:)=abs(fft(cp11(h,:))); 
 end
mesh(1:N,1:mc+1,r_fft1);
hold on;                                                                   %按距离门进行FFT输出  
end
box on;
title('单目标FFT波形')
%--------------------------多普勒敏感现象----------------------------------%

%% ************************双目标******************************* %%
n_delay2=fix(tr2*fm);                                                      %延迟的码元个数,tr2为雷达波从目标1回波的延时，fm为码频
m_delay2=zeros(1,mc);                                                      %m_delay为回波的单周期m序列，生成矩阵空间
m_delay2(1:n_delay2)=m_127(mc-n_delay2+1:mc);                              %前几个是原m序列的后几个
m_delay2(n_delay2+1:mc)=m_127(1:mc-n_delay2);                              %后几个是原m序列的前几个
mr2=repmat(m_delay2,1,N);                                                  %解调后m序列，延迟n_delay个码元，包含了目标距离信息
j2=1:mc*N;                                                                 %自变量
sr2=A2*mr2.*cos(2*pi*fd2/fm*j2);                                           %目标1的回波信号               
sr2_snr=awgn(sr2,snr,'measured');                                          %信噪比为snr,awgn指加性高斯白噪声
sr=sr1+sr2;
sr_snr=sr1_snr+sr2_snr;

%% ---------------------------脉压----------------------------- %%
k=fliplr(m_127);                                  
my=conv(sr_snr,k);                                                         %脉冲压缩处理
figure(5),plot(abs(my));                                                   %绘制脉压后的波形  
title('双目标脉冲压缩后的波形');

%% ---------------------------FFT------------------------------ %%
for r=1:N    
    for h=1:mc         
        cp(h,r)=my((r-1)*mc+h);     
    end
end
cp=cp';
cp=[cp,zeros(78,1)];
cp=cp';
%figure(6),mesh(1:N,1:mc+1,cp);                                            %距离门重排
%title('双目标FFT波形')

for h=1:mc+1  
    r_fft(h,:)=abs(fft(cp(h,:))); 
end
figure(6),mesh(1:N,1:mc+1,r_fft);                                          %按距离门进行FFT输出
title('双目标FFT波形')

%% -------------------- 主旁瓣比与多普勒频率 ------------------- %%
fdht=[0:500:4000];
zhuban=[0.5*9.845e5,4.824e5,4.69e5,4.471e5,4.172e5,3.751e5,3.409e5,3.2053e5,3.092e5];
%pangban=[8300,9769,1.758e4,2.489e4,3.122e4,3.63e4,4.016e4,4.333e4];       %此处不考虑旁瓣
%rate=zhuban./pangban;
zhuban=20*log10(zhuban);
xx=0:10:4000;
yy=interp1(fdht,zhuban,xx,'cublic');
figure(7),plot(xx,yy,fdht,zhuban,'.');
title('主瓣与多普勒频率的关系');
xlabel('多普勒频率fd/Hz');
ylabel('主瓣幅度/dB');

