clear all;
close all;
clc;
%================================����==================================
fm=2e6;%��Ƶ
fc=10e9;%��Ƶ
c=3e8;%����
t=10e-3;%��ɻ�����ʱ��
T=1/fm*1270;%��λ��������
N=15;%�����ظ�����(t/T)
%==============================m���в���=================================
connection=[1 0 0 0 0 0 1];
n=length(connection);
reg=[0 0 0 0 0 0 1 ];
mseqmatrix(1)=reg(n);
for i=2:127 
  newreg(1)=mod(sum(connection.*reg),2);
for j=2:n
  newreg(j)=reg(j-1);
end
reg=newreg;
mseqmatrix(i)=reg(n);
end
m_bip=2*mseqmatrix-1;%˫ֵ��ƽ
%=============================��Ŀ��====================================

pipei=fliplr(m_bip);%�����ش�ֱ�����ҷ�ת
hbb=conv(pipei,m_bip);

    for p=1:127*5
        c=0;
        for k=1:127
            if (mod((p+k),127)==0)
                m1=127;
            else 
                m1=mod(p+k,127);
            end
        c=c+m_bip(k)*m_bip(m1);
        end
        zxg(p)=c;
    end
figure;plot(zxg);
title('3.m���е�˫ֵ��ƽѭ������غ���');
set(gca,'Ytick',127,'Xtick',127);