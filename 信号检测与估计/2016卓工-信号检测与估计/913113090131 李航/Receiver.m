function y= Receiver(Vr,R0,Ar,SNR)
%Vr为目标速度 R0为目标距离 Ar为目标幅度 SNR为输入信噪比
T=4e-3;%最大相参积累时间
c=3e8;%电磁波传播的速度
Fc=10e9;%载波的频率
Fm=31e6;%码元的频率
N=floor(T*Fm/127);;%相参累积的周期数
Fd=(2*Vr)/(c/Fc); %多普勒频率
d0=(4*pi*R0*Fc)/c; %回波相移
t=1/Fc:1/Fm:((N*127)-1)/Fm+1/Fc;
R=R0-Vr*t;
Tr=(2*R)/c;
if(Vr~=0)
     Rsignal=Ar*PRFC(t-Tr).*exp(1j*2*pi*Fd*t-1j*d0);
     y=Rsignal;
else
    Rsignal=Ar*PRFC(t-Tr);
    y=Rsignal;
end
%y=awgn(y,SNR,'measured');


end

