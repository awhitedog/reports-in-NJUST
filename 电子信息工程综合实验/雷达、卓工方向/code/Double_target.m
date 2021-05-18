clc;
clear;
B=10e6;                 %����
T=50e-6;               %����
Tau=2e-6;                %����
Fc=16e9;            %��Ƶ
SNRi=-5;              %���������
V1=20;              %Ŀ���ٶ�1
V2=30;           %�ٶ�2
A1=8;               %Ŀ�����
A2=8;            %Ŀ�����
tt=10e-3;           %��ɻ���ʱ��
%******************�������м����*******************
D=Tau/T;            %ռ�ձ�
K=B/Tau;              %���Ե�Ƶб��
fs=2*B*10;             %����Ƶ��
Ts=1/fs;            %��������
C=3e8;              %����C
M=64;             %�����ظ�����
%******************���Ե�Ƶ�ź�***************
R1=120;            %����1
R2=120;          %����2

N=round(T/Ts);
t1=linspace(-Tau/2,Tau/2,N*D);
t_0=linspace(-T/2,T/2,N);
St_0=exp(j*pi*K*t1.^2);
N1=round(N*(1-D)/2);
f=linspace(-fs/2,fs/2,N);
zero=zeros(1,N1);%����
St=[zero,St_0,zero];
%***************�ز��ź�**********************
St_repeat=repmat(St,1,M+1);
%St_repeat=St;
t_Delay1=2*R1/C;     t_Delay2=2*R2/C; %��ʱ
N_R1=round(t_Delay1/Ts);N_R2=round(t_Delay2/Ts);
zero_left1=zeros(1,N1+N_R1);zero_left2=zeros(1,N1+N_R2);
zero_right1=zeros(1,N1-N_R1);zero_right2=zeros(1,N1-N_R2);
St1=A1*[zero_left1,St_repeat];       St2=A2*[zero_left2,St_repeat];
St1=St1(:,1:(M+1)*N);    St2=St2(:,1:(M+1)*N);
fd1=2*V1/(C/Fc);     fd2=2*V2/(C/Fc);%������Ƶ��
i=1:N*(M+1);
St_Dop1=exp(2*j*pi*fd1*Ts*i);       St_Dop2=exp(2*j*pi*fd2*Ts*i);%��������ʱƵ���źŲ���
St_M=St1.*St_Dop1+St2.*St_Dop2;%��������Ƶ�Ƶ��ź�
St_M_Gauss=randn(1,size(St_M,2))+j*randn(1,size(St_M,2));%����������
 [filterB,filterA] = butter(12,0.5,'low');%20�׵�ͨ������˹�˲���
 [h,w]=freqz(filterB,filterA);
 St_M_Gauss=filter(filterB,filterA,St_M_Gauss);
St_M_with=St_M+St_M_Gauss;
%*************ƥ���˲�������ѹ����************
Ht_0=fliplr(St);
Ht=conj(Ht_0);
St_H_with=conv(St_M_with,Ht);
plot(abs(real(St_H_with)));
 grid on;axis tight;
%*********************��������***********
 for r=1:M
for h=1:N
position=(r-1)*N+h+N*(1-D)/2;
St_fft_arrange_with(h,r)=St_H_with(position);
end
 end
%*******************FFT*********************
for h=1:N
St_fft_with(h,:)=(abs(fft(St_fft_arrange_with(h,:))));
end
mesh(1:M,1:N,(St_fft_with));
%*******************���ݳ�ȡ*****************
k=60;
for h=1:k
    St_fft_with_chose(h,:)=St_fft_with(h,:);
end


 