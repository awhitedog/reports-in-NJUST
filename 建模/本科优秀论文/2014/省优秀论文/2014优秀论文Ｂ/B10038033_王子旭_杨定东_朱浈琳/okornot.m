function [flag  thita] = okornot( DD,H,bianchang,geshu,namda,houdu )


%DD            直径
%H             高度
%bianchang     边长
%geshu         分的个数
%namda         0-1钢筋在活动部位的比例
%houdu         木板的厚度
%flag          1 表示可以
%zhinxin       质心
%thita         第一根木条的角度 弧度制

R=DD/2;H=H-houdu;
dd=DD/geshu;sd=dd/2;sd1=sd;

isjishu=1;
if mod(geshu,2)==1 
    geshu=geshu+1;
    isjishu=0;
end;

dist=zeros(geshu/2,1);%dist是每个木条转轴处距离中轴线的距离
z1=zeros(geshu,1);
for i=1:geshu/2
    z1(i)=sd;
    if isjishu==0
        dist(geshu/2-i+1)=sqrt(R^2-(sd-sd1)^2);
    else
        dist(geshu/2-i+1)=sqrt(R^2-sd^2);
    end;
    sd=sd+dd;
end
changdu=bianchang/2-dist;   %是每根木条的长度
xx=zeros(geshu/2,1);%xx是距离第一条转轴长度即各个木条的横坐标
xx=dist;
if isjishu==0
      z1(geshu/2+1)=z1(geshu/2);
else
      z1(geshu/2+1)=z1(geshu/2)+dd;
end;
for i=geshu/2+2:geshu
    z1(i)=z1(i-1)+dd;
end;
z2=z1;
z1=z1-R;z2=z2-R;

l=namda*(bianchang/2-dist(1));
x1=zeros(geshu,1);y1=zeros(geshu,1);
x1=dist;
thita=asin(H/changdu(1));
x=l*cos(thita)+dist(1);
y=l*sin(thita);
x2=zeros(geshu,1);
y2=zeros(geshu,1);
flag=1;
if l+dist(1)<R 
    flag=0;
end;
for j=1:geshu/2;
    qujian(i,j)=sqrt((x-xx(j))^2+y^2);
    if qujian(i,j)>changdu(j)
       flag=0;
    end;
    y2(j)=changdu(j)/qujian(i,j)*y;
    x2(j)=xx(j)-(changdu(j)/qujian(i,j)*(xx(j)-x));
    if x2(j)<0
        flag=0;
    end;
end



