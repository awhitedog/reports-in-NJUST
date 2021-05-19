clc;
clear;
tb=[];%储存时间的比较函数
ssb=0;
for j=1:100
x=[];
y=[];
xl=[];
yl=[];
tt=1;
tk=230;%初始的t
N=0;%N记录节数的变化
v=11.32;
vs=13.89;%27节的速度
v1=18.01;
time=0;%记录被击中的次数
a=1;
aa=109.9533;%加速度
temaa=109.9533;%初始的加速度
dd=3900;%记录初始冲距
x(1)=0;
y(1)=0;
H(1)=0;
Hsum=0;%记录转向的总角度
X=rand(1);%初始鱼雷位置角度，单位为π
Hl(1)=asin(v/v1*sin(X*pi));%Hl(1)=rand(1).*pi;%初始速度角度，单位为π
xl(1)=5557.5.*cos(X.*pi);
yl(1)=5557.5.*sin(X.*pi);
ds=sqrt((yl(1)-y(1)).^2+(xl(1)-x(1)).^2);
tb(j)=0;%储存转弯的时间
i=0;%储存转弯次数
   while ds>2778.75&&tt<200%判断距离与转弯次数
       temt1=tk;%储存t的值
       t=rand(1)/60;%随机生成转弯时间,单位分钟，单位分度：1s
       tk=tk+t;%用于计算v0t
       v2=(22+(aa+1.8425*(-27))*t)/(1-1.8425*t)*1852.5/3600;%根据时间与加速度解出加速后的速度，单位m/s
       jie=v2*3600/1852.5;%将速度转化为节数
       N=(v2-vs)*3600/1852.5;%储存节数的改变
       r=-0.3886*jie^3+25.628*jie^2-469.74*jie+2917.9;%根据速度计算转弯半径
       aa=aa+1.8425*(v2-vs)*3600/1852.5;%加速度随着v的变化而变化，初始速度都是22节
       dd=dd-v*temt1-1.8*temaa^2-119.5*N+v*tk+1.8*aa^2;%计算冲距，初始速度22节
       temaa=aa;
       vs=v2;%储存速度参数
       tb(j)=tb(j)+t;%记录总时间，比较优劣
       i=i+1;
       H(i+1)=a.*H(i)+dd/r;%计算转弯角度
       Hsum=Hsum+H(i+1);
       x(i+1)=x(i)+r.*sin(H(i+1));%转弯时x轴的偏移
       y(i+1)=y(i)+r.*cos(H(i+1));%转弯时y轴的偏移
       temx=x(i+1);%临时记录x的值
       temy=y(i+1);%临时记录y的值
       temt=tb(j);%临时记录t的值
       temi=i;%临时记录i的值
       temtt=tt;%临时记录tt的值
       temds=ds;%临时记录ds的值
       temHsum=Hsum;%临时记录Hsum的值
  %          Hl(i+1)=Hl(i);%
            xl(i+1)=xl(i)-v1.*t.*sin(H(1));
            yl(i+1)=yl(i)-v1.*t.*cos(H(1));
            ds=sqrt((yl(i+1)-y(i+1)).^2+(xl(i+1)-x(i+1)).^2);
            tt=tt+1;
            while ds>2778.75&&tt<200%判断直行时能否击中
               t1=rand(1).*50;%生成随机时间，开始测试能否击中  
               tb(j)=tb(j)+t;%记录总时间，比较优劣
               i=i+1;
               H(i+1)=H(i);%转弯角度保持不变
               x(i+1)=x(i)+v.*t1.*cos(H(i+1));
               y(i+1)=y(i)+v.*t1.*sin(H(i+1));%计算直行时的偏移             
                 %  Hl(i+1)=Hl(i);%
                   xl(i+1)=xl(i)-v1.*t1.*sin(H(1));
                   yl(i+1)=yl(i)-v1.*t1.*cos(H(1));
                   ds=sqrt((yl(i+1)-y(i+1)).^2+(xl(i+1)-x(i+1)).^2);
                   tt=tt+1;
            end
            if tt>=199%证明一直没有中
               temi
               if temi==1
                   X
                   H(2)
                  % H(3)
                  % H(4)
               end 
               
               ssb=ssb+1;
               break;
            else %中了
               i=temi;%临时记录i的值
               x(i+1)=temx;%临时记录x的值
               y(i+1)=temy;%临时记录y的值
               tb(j)=temt;%临时记录t的值
               tt=temtt;%临时记录tt的值
               ds=temds;
               time=time+1;%被击中次数加一
               if time==50
                  break;%50次都跳不出，则直接结束
               end
            end
  end
end
tb
ssb