%�Ƕȵ�λ���ǻ���
clc
clear;
x=atan((5557.5*sin(0.4*pi)+911.65)./(5557.5*cos(0.4*pi)-805.6603));
R = normrnd(x,1./36.*pi,1000); %����100����ֵΪx,��׼��Ϊ1./36.*pi��������̬�ֲ�����
b=zeros(20,1000);
q=1;%��¼���ݵ�λ��
v=11.92;
   %for y=(x-1./36.*pi):0.1:(x+1./36.*pi)%
    for i=1:1000
        nn=1;
        y=R(i);
        a(i)=asin((v/18.01)*sin(y));
        [max_a,index]=max(a);
        [min_a,index1]=min(a);
        diff=max_a-min_a;
        for j=min_a:(diff/20):(max_a-diff/20)
            d(nn)=j;
            nn=nn+1;%�������Եֵ����
            if a(i)>j&&a(i)<(j+diff/20)
                p=(j-min_a).*20./diff+1;%p��¼�ǵڼ�������
                p=int32(p);
                b(p,q)=a(i);
                q=q+1;
            end
        end
    end
t=0;%��������Ԫ�ظ���
for i=1:20
    for j=1:1000
        if b(i,j)~=0
           t=t+1;
        end 
    end
    c(i)=t%������ִ�������
    t=0;
end

 plot(d(1,:),c(1,:));%��һ��ͼ���ϻ���ͼ��
grid on%�ڱ�������դ��
 xlabel('����ֵ')%���Ӻ���������
 ylabel('����')%��������������
title('�������������')     %���ͼ�����
% gtext('sin(x)') % �����Ĺ�궨λ,��sinx���ע�����������ĵط�
