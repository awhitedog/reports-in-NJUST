C=3e8;                            %����
B=10e6;                           %����10MHz
F0=16e9;                          %�ز�Ƶ��16Ghz
Fs=100e6;                         %����Ƶ��100MHz
Tr=100e-6;                         %ʱ��100us
Tau=2e-6;                          %����2us

v1=40;                         
v2=80;
lemda=C/F0;
fd1=2*v1/lemda;                     %������Ƶ��
fd2=2*v2/lemda;

R1=400;
R2=1000;
delay1=2*R1/C;
delay2=2*R2/C;

%������������Ƶ�ź�
K=B/Tau;
n1=(-Tau/2:1/Fs:Tau/2);
n2=(0:1/Fs:Tr);
sn0=exp(1j*(2*pi*F0*n1+pi*K*n1.^2));%��Ƶ
sn=exp(1j*(pi*K*n1.^2));%���� 

%�����ز��źŲ�����Ƶ��
N1=round(Tau*Fs);
N2=round(Tr*Fs);
N0=size(sn0,2);
sn01=exp(1j*(2*pi*(fd1+F0)*n1+pi*K*n1.^2));
sn02=exp(1j*(2*pi*(fd2+F0)*n1+pi*K*n1.^2));
Ndelay1=round(delay1*Fs);
Ndelay2=round(delay2*Fs);
sr1=[zeros(1,Ndelay1) sn01 zeros(1,N2-N0-Ndelay1+1)];
sr2=[zeros(1,Ndelay2) sn02 zeros(1,N2-N0-Ndelay2+1)];
sr=sr1+sr2;
figure(1);
dbw_sr=10*log10((sum(abs(sn0.^2)))/length(sn0));
sr=awgn(sr,30,dbw_sr);
subplot(211);plot(n2,real(sr));title('��Ƶ�ź�');
spectrum=abs(fft(real(sr)));
spec=[spectrum(end/2:end) spectrum(1:end/2)];
x=(-Fs/2:Fs/(size(sr,2)-1):Fs/2);
subplot(212);plot(x,spec);title('Ƶ��');
set(gca,'XTick',[-100e6 -75e6 -50e6 -25e6 0 25e6 50e6 75e6 100e6]);

%�±�Ƶ���˲���������ź�
hunpin=sr.*cos(2*pi*F0*n2);
Hk=Dgfilter(10e6,15e6,400e6);        %���������˲�������
sjidai=conv(hunpin,Hk);
figure(2);
subplot(211);plot((0:Tr/(size(sjidai,2)-1):Tr),sjidai);title('����');
sjidai_down=sjidai(1:2:end);
spectrum=abs(fft(sjidai_down));
spec=[spectrum(end/2:end) spectrum(1:end/2)];
x=(-Fs/4:Fs/2/(size(spec,2)-1):Fs/4);
subplot(212);plot(x,spec);title('�����ź�Ƶ��');

%ƥ���˲�
ht=exp(-1j*pi*K*n1.^2);
srmy=conv(ht,sjidai);
n3=(0:1/Fs:(size(srmy,2)-1)/Fs);
figure(3);
subplot(211);plot(n3,real(srmy));title('����ѹ��');
 
srmy=srmy./max(srmy);
srmy_db=20*log10(abs(srmy));
subplot(212);plot(n3,srmy_db);title('����ѹ��--dB');
