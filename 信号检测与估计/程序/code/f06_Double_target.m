clc;
clear;
B=34e6;                 %����
T=200e-6;               %����
D=10e-2;            %ռ�ձ�
Fc=10e9;            %��Ƶ
SNRi=-5;              %���������
V1=20;              %Ŀ���ٶ�1
V2=22;           %�ٶ�2
A1=10;               %Ŀ�����
A2=3;            %Ŀ�����
tt=20e-3;           %��ɻ���ʱ��
%******************�������м����*******************
Tau=D*T;                %����
K=B/T;              %���Ե�Ƶб��
fs=2*B;             %����Ƶ��
Ts=1/fs;            %��������
C=3e8;              %����C
M=tt/T;             %�����ظ�����
%******************���Ե�Ƶ�ź�***************
R1=262;            %����1
R2=262;          %����2

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
t_Delay1=2*R1/C;     t_Delay2=2*R2/C; %��ʱ
N_R1=round(t_Delay1/Ts);N_R2=round(t_Delay2/Ts);
zero_left1=zeros(1,N1+N_R1);zero_left2=zeros(1,N1+N_R2);
St1=A1*[zero_left1,St_repeat];       St2=A2*[zero_left2,St_repeat];
St1=St1(:,1:(M+1)*N);    St2=St2(:,1:(M+1)*N);
fd1=2*V1/(C/Fc);     fd2=2*V2/(C/Fc);%������Ƶ��
i=1:N*(M+1);
St_Dop1=exp(2*j*pi*fd1*Ts*i);       St_Dop2=exp(2*j*pi*fd2*Ts*i);%��������ʱƵ���źŲ���
St_M=St1.*St_Dop1+St2.*St_Dop2;%��������Ƶ�Ƶ��ź�
 [filterB,filterA] = butter(12,0.05,'low');%20�׵�ͨ������˹�˲���
 [h,w]=freqz(filterB,filterA);
 St_M_Gauss=filter(filterB,filterA,randn(size(St_M)));
St_M_with=St_M+St_M_Gauss;
%*************ƥ���˲�������ѹ����************
Ht_0=fliplr(St);
Ht=conj(Ht_0);
St_H_with=conv(St_M_with,Ht);
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
%*******************���ݳ�ȡ*****************
k=200;
for h=1:k
    St_fft_with_chose(h,:)=St_fft_with(h,:);
end

%*******************����ֱ���*************
% figure(6);
% subplot(211);
% mesh(1:M,1:k,(St_fft_with_chose));
% xlabel('������');
% ylabel('������');
% title(['�����Ϊ',num2str(R2-R1),'m�����']);
% figure(6);
% subplot(212);
% mesh(1:M,1:k,(St_fft_with_chose));
% view(-90,0);
% title(['����ͶӰ']);

%*******************�ٶȷֱ���*************
% figure(7);
% subplot(211);
% mesh(1:M,1:k,(St_fft_with_chose));
% xlabel('������');
% ylabel('������');
% title(['�ٶȲ�Ϊ',num2str(V2-V1),'m/s�����']);
% figure(7);
% subplot(212);
% mesh(1:M,1:k,(St_fft_with_chose));
% view(0,0);
% title(['�ٶ�ͶӰ']);

%*******************�ڸ�*************
figure(8);
subplot(311);
mesh(1:M,1:k,(St_fft_with_chose));
xlabel('������');
ylabel('������');
title(['�����',num2str(R2-R1),'m �ٶȲ�',num2str(V2-V1),'m/s']);
figure(8);
subplot(312);
mesh(1:M,1:k,(St_fft_with_chose));
view(-90,0);
title(['����ͶӰ']);
figure(8);
subplot(313);
mesh(1:M,1:k,(St_fft_with_chose));
view(0,0);
title(['�ٶ�ͶӰ']);


 