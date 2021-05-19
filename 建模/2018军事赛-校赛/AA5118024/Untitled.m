%角度单位都是弧度
clc
clear;
x=atan((5557.5*sin(0.4*pi)+911.65)./(5557.5*cos(0.4*pi)-805.6603));
R = normrnd(x,1./36.*pi,1000); %生成100个均值为x,标准差为1./36.*pi，服从正态分布的数
b=zeros(20,1000);
q=1;%记录数据的位置
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
            nn=nn+1;%将区间边缘值存入
            if a(i)>j&&a(i)<(j+diff/20)
                p=(j-min_a).*20./diff+1;%p记录是第几个区间
                p=int32(p);
                b(p,q)=a(i);
                q=q+1;
            end
        end
    end
t=0;%计算区间元素个数
for i=1:20
    for j=1:1000
        if b(i,j)~=0
           t=t+1;
        end 
    end
    c(i)=t%储存出现次数矩阵
    t=0;
end

 plot(d(1,:),c(1,:));%在一张图表上画的图像
grid on%在表上增加栅格
 xlabel('区间值')%增加横坐标名称
 ylabel('个数')%增加纵坐标名称
title('各区间变量个数')     %添加图像标题
% gtext('sin(x)') % 用鼠标的光标定位,将sinx这个注解放在鼠标点击的地方
