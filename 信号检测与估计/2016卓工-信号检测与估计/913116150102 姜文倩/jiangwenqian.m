clc;
clear;
fm=2e6; ;%��Ƶ ; 
fc=10e9;%��Ƶ 
t=10e-3; %��ɻ�����ʱ�� 
T=1/fm*1270; 
N=15; %����ʱ�䲻����10ms��N<t/T
snr=-10;%���������
v1=8;
r1=600;
v2=8;
r2=300;
c=3e8;
fbconnection=[0 0 1 0 0 0 1];
n = length(fbconnection);
m = 2^n-1;
x=10*m;
register = [1 0 1 0 1 0 1];%������λ�Ĵ����ĳ�ʼ״̬
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
%------------------0��ʱ��0�����ʵĻز�--------------------------%
%������غ���
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
title('ѭ������غ���');
xlabel('����');
ylabel('����');

%------------------10��ʱ���ж����ʵĻز�-------------------%
f1=2e6
hbtemp=repmat(m_1270,1,N)%repmat �� Replicate Matrix �����ƺ�ƽ�̾����� MATLAB �����һ������
yanchi1=fix(2*r1*f1/c);
m_3=[zeros(1,yanchi1) m_1270(1:1270-yanchi1)];
m3=100*[zeros(1,yanchi1) hbtemp(1:1270*N-yanchi1)];
fd1=2*v1/0.03;
for i=1:1270*N;
 duopule(i)=cos(2*pi*fd1/fm*i);
end
hb0=m3.*duopule;
hb=awgn(100*hb0,snr,'measured');%y = awgn(x,SNR) ���ź�x�м����˹�������������SNR��dBΪ��λ��
% %���SIGPOWER����ֵ�����������dBWΪ��λ���ź�ǿ�ȣ����SIGPOWERΪ'measured'���������ڼ�������֮ǰ�ⶨ�ź�ǿ�ȡ�
 hb1=hb;
% ------------------��ѹ������������������������%

pipei=fliplr(m_1270);
hbb1=conv(pipei,hb1);

% %-----------------����������------------------%
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
hb10=awgn(100*hb11,snr,'measured');%y = awgn(x,SNR) ���ź�x�м����˹�������������SNR��dBΪ��λ��
% %���SIGPOWER����ֵ�����������dBWΪ��λ���ź�ǿ�ȣ����SIGPOWERΪ'measured'���������ڼ�������֮ǰ�ⶨ�ź�ǿ�ȡ�
 hb2=hb10;
% ------------------��ѹ������������������������%
hbz=hb1+hb2;
pipei=fliplr(m_1270);
hbb2=conv(pipei,hbz);
% %-----------------����������------------------%
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




