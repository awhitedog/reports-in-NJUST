%������m���е���ѹ��˵����ѹ���棬����������������
clear all;
close all;
clc;
N=1;
M=200;
snr=0;
fm=12e6;%��Ƶ
fc=10e9;%��Ƶ
m_127=m_sequence([1 0 0 0 0 0 1]);
mbip_127=2*m_127-1;%˫����m����;
%��ѭ������أ���Nֵ
m_n=repmat(mbip_127,1,N);
pipei=fliplr(mbip_127);
zxgm_n=conv(pipei,m_n);
figure(9);plot(zxgm_n);
title('m���е�ѭ������غ���')
for n=1:M;
  fd(n)=1000*n;
  for i=1:127*N;
     doppler(n,i)=exp(j*2*pi*fd(n)/fm*i); 
  end
end  
%��ѹ
pipei=fliplr(mbip_127);
for m=1:M
 mm_n(m,:)=m_n.*doppler(m,:);%�Ӷ�����Ƶ��
 maiya(m,:)=conv(pipei,mm_n(m,:));
end
figure(1);
mesh(abs(maiya));
title('��ѹ����������Ƶ�ʵĹ�ϵ')
ylabel('������Ƶ��/KHz');xlabel('��������');zlabel('����');
%127�������Ա�
posmaiya=abs(maiya);
pangban=maiya;
pangban(:,127)=[];
for a=1:M;
  zhuban(a)=max(posmaiya(a,:));
  mpangban(a)=max(abs(pangban(a,:)));
  zhupangbi(a)=zhuban(a)/mpangban(a);
  zhupangbidb(a)=20*log10(zhupangbi(a));
end  

% %63λm����
m_63=m_sequence([1 0 0 0 0 1]);
mbip_63=2*m_63-1;%˫����m����;
m_n_63=repmat(mbip_63,1,N);
for n2=1:M;
  fd(n2)=1000*n2;
  for i2=1:63*N;
     doppler2(n2,i2)=exp(j*2*pi*fd(n2)/fm*i2); 
  end   
end
%��ѹ
pipei2=fliplr(mbip_63);
for m2=1:M
 mm_n_63(m2,:)=m_n_63.*doppler2(m2,:);%�Ӷ�����Ƶ��
 maiya_63(m2,:)=conv(pipei2,mm_n_63(m2,:));
end
figure(2);
mesh(abs(maiya_63));
title('�볤63��m������ѹ����������Ƶ�ʵĹ�ϵ')
ylabel('������Ƶ��/KHz');xlabel('��������');zlabel('����');
%63�������Ա�
posmaiya2=abs(maiya_63);
pangban2=maiya_63;
pangban2(:,63)=[];
for a=1:M;
  zhuban2(a)=max(posmaiya2(a,:));
  mpangban2(a)=max(abs(pangban2(a,:)));
  zhupangbi2(a)=zhuban2(a)/mpangban2(a);
  zhupangbidb2(a)=20*log10(zhupangbi2(a));
end  

figure(3);plot(fd,20*log10(zhuban),'g',fd,20*log10(zhuban2),'r')
grid on;
set(gca,'Ytick',[32.05,35.99,38.13,42.07],'Xtick',[47244,95238]);
title('m��������߶��������Ƶ�Ƶı仯����')
xlabel('Ƶ��/Hz');ylabel('����/db');
figure(4);plot(fd,zhupangbidb,'g',fd,zhupangbidb2,'r')
grid on;
title('m�������԰���������Ƶ�Ƶı仯����')
xlabel('Ƶ��/Hz');ylabel('����/db');
