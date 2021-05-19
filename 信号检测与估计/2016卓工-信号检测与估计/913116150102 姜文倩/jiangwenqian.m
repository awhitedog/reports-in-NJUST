clc;
clear;
fm=2e6; ;%码频 ; 
fc=10e9;%载频 
t=10e-3; %相干积累总时宽 
T=1/fm*1270; 
N=15; %积累时间不大于10ms，N<t/T
snr=-10;%输入信噪比
v1=8;
r1=600;
v2=8;
r2=300;
c=3e8;
fbconnection=[0 0 1 0 0 0 1];
n = length(fbconnection);
m = 2^n-1;
x=10*m;
register = [1 0 1 0 1 0 1];%定义移位寄存器的初始状态
mseqmatrix(1)= register(n);
for i = 2:m
    newregister(1)= mod(sum(fbconnection.*register),2);
    for j = 2:n
        newregister(j)= register(j-1);
    end
    register = newregister;
    mseqmatrix(i) = register(n);
end
m_127=2*mseqmatrix-1;
m_1270=[m_127 zeros(1,1143)];
%------------------0延时，0多普率的回波--------------------------%
%求自相关函数
N1=length(m_127);
t=0:127*N;
for i=0:127*N
    si=0
    for j=1:127
        if(mod((j+i),127)==0)
            k=127;
        else
            k=mod((i+j),127);
        end
        si=si+m_127(j)*m_127(k);
    end
    S(i+1)=si;
end
figure;
plot(t,S);
title('循环自相关函数');
xlabel('距离');
ylabel('幅度');

%------------------10延时，有多普率的回波-------------------%
f1=2e6
hbtemp=repmat(m_1270,1,N)%repmat 即 Replicate Matrix ，复制和平铺矩阵，是 MATLAB 里面的一个函数
yanchi1=fix(2*r1*f1/c);
m_3=[zeros(1,yanchi1) m_1270(1:1270-yanchi1)];
m3=100*[zeros(1,yanchi1) hbtemp(1:1270*N-yanchi1)];
fd1=2*v1/0.03;
for i=1:1270*N;
 duopule(i)=cos(2*pi*fd1/fm*i);
end
hb0=m3.*duopule;
hb=awgn(100*hb0,snr,'measured');%y = awgn(x,SNR) 在信号x中加入高斯白噪声。信噪比SNR以dB为单位；
% %如果SIGPOWER是数值，则其代表以dBW为单位的信号强度；如果SIGPOWER为'measured'，则函数将在加入噪声之前测定信号强度。
 hb1=hb;
% ------------------脉压————————————%

pipei=fliplr(m_1270);
hbb1=conv(pipei,hb1);

% %-----------------距离门重排------------------%
for r=1:N
    for h=1:x
        s_hb1(h,r)=hbb1((r-1)*x+h);
    end
end
figure;mesh(1:N,1:1270,s_hb1);
% % %------------------fft------------------------------
for h=1:x
r_fft(h,:)=abs(fft(s_hb1(h,:)));
end
figure;
mesh(r_fft);

f1=2e6;
yanchi2=fix(2*r2*f1/c);
m_4=[zeros(1,yanchi2) m_1270(1:1270-yanchi2)];
m4=[zeros(1,yanchi2) hbtemp(1:1270*N-yanchi2)];
fd2=2*v2/0.03;
for i=1:1270*N;
 duopule1(i)=cos(2*pi*fd2/fm*i);
end
hb11=m4.*duopule1;
hb10=awgn(100*hb11,snr,'measured');%y = awgn(x,SNR) 在信号x中加入高斯白噪声。信噪比SNR以dB为单位；
% %如果SIGPOWER是数值，则其代表以dBW为单位的信号强度；如果SIGPOWER为'measured'，则函数将在加入噪声之前测定信号强度。
 hb2=hb10;
% ------------------脉压————————————%
hbz=hb1+hb2;
pipei=fliplr(m_1270);
hbb2=conv(pipei,hbz);
% %-----------------距离门重排------------------%
for r=1:N
    for h=1:x
        s_hb2(h,r)=hbb2((r-1)*x+h);
    end
end

figure;
mesh(s_hb2)

% % %------------------fft------------------------------
for h=1:x
r_fft2(h,:)=abs(fft(s_hb2(h,:)));
end
figure;
mesh(1:N,1:1270,r_fft2);




