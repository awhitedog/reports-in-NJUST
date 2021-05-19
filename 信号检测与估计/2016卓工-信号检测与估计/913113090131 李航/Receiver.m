function y= Receiver(Vr,R0,Ar,SNR)
%VrΪĿ���ٶ� R0ΪĿ����� ArΪĿ����� SNRΪ���������
T=4e-3;%�����λ���ʱ��
c=3e8;%��Ų��������ٶ�
Fc=10e9;%�ز���Ƶ��
Fm=31e6;%��Ԫ��Ƶ��
N=floor(T*Fm/127);;%����ۻ���������
Fd=(2*Vr)/(c/Fc); %������Ƶ��
d0=(4*pi*R0*Fc)/c; %�ز�����
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

