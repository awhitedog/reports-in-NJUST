clear all;
close all;
clc;
%================================条件==================================
fm=2e6;%码频
fc=10e9;%载频
c=3e8;%光速
t=10e-3;%相干积累总时宽
T=1/fm*1270;%相位编码周期
N=15;%周期重复次数(t/T)
%==============================m序列产生=================================
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
m_bip=2*mseqmatrix-1;%双值电平
%=============================单目标====================================

pipei=fliplr(m_bip);%矩阵沿垂直轴左右翻转
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
title('3.m序列的双值电平循环自相关函数');
set(gca,'Ytick',127,'Xtick',127);