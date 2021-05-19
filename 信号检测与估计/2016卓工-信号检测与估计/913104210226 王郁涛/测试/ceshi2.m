%
fc = 10e9;                          %载波 10GHz
fs=2*fc;
c = 3e8;                            %光速
l = c/fc;                           %载波波长
T = 200e-6;                         %时宽 200us,脉冲重复周期 200us
t=0:1/fs:10*T;                      %采样频率为步长,采样10个脉冲
B = 26e6;                           %调频带宽 26MHz
A=1;                                %目标幅度
s1 = 1000;                          %目标距离
vr =10;                             %目标速度
fd = 2*vt/l;                        %对应的多普勒频率  
K=B/T;                              %调频斜率
t1=2*s1/c;                          %雷达波从目标1回波的延时     
st1=rectpuls(t,T).*exp(j*2*pi*(fc*t+0.5*K*t.^2));                    %发射信号
sr00=A*rectpuls((t-t1),T).*exp(j*2*pi*(fc*(t-t1)+0.5*K*(t-t1).^2));    %无噪声无多普勒频移的目标1回波
figure(3);
subplot(211);
plot(real(st1));
title('发射信号');
axis([9.5e4,1.7e5,-2,2]);
figure(4);
subplot(212);
plot(real(sr00));
title('无噪声无多普勒频移的目标1回波');
axis([9.5e4,1.7e5,-2,2]);