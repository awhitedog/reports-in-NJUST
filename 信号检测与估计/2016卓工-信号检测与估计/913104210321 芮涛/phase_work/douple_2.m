%����������ʧ����
clear all;
M_creater;
%�ز�����
Am=20;
fe=21e6;
p=127;
snr=-10;
N=500;

%����������ʧ����
for k=1:11
%0�ӳٶ����ջز��ź�
s_in=repmat(m_dline,1,N);  %0�ӳ�0�����ʻز�
%s_in=awgn(s_in,snr,'measured');%�����˹������Ļز�
fd=(k-1)/10*fe/p;
i=0:p*N-1;
s_in=s_in.*cos(2*pi*fd/fe*i);  %���������Ƶ�ƺ�Ļز��ź�

%��ѹ����ƥ���˲���
ht=fliplr(m_dline);
s_out=conv(s_in,ht); %ʱ�������ƥ���˲�
%����������
for j=1:N
    for i=1:p
        s_out_r(i,j)=s_out((j-1)*p+i);
    end
end
for j=1:N
    a_line=(s_out_r(:,j))';
    a_line=abs(a_line);
    t_max=max(a_line);
    a_label=find(a_line==t_max);
    a_line(a_label)=[];
    p_max=max(a_line);
    d_p(j)=t_max/p_max;
   
end
    s_p(k)=sum(d_p)/N;
end
s_p=20*log10(s_p);
k=0:10;
plot(k,s_p)
title('������Ƶ�Ƶ��µ���ѹ��ʧ����');
xlabel('x10e-1��ԪƵ��');
ylabel('���԰��/dB');

