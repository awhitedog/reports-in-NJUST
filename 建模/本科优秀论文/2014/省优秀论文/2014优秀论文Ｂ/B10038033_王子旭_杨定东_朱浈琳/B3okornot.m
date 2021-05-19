function [flag,m,changduleft,changduright,distleft,distright,l1,r1] = B3okornot( DD,H,geshu,houdu,namda,namda2,thita,thita2 )
%B3OKORNOT Summary of this function goes here
%   Detailed explanation goes here
%DD=80;%由用户给出 注意还没有减去houdu;
% 本次确定钢筋的位置从最能够使得桌子建成的角度出发，也是可以自己设定的
R=DD/2;H=H-houdu;
dd=DD/geshu;sd=dd/2;sd1=sd;
isjishu=1;
if mod(geshu,2)==1 
    geshu=geshu+1;
    isjishu=0;
end;

sd=dd/2; 
x1left=zeros(geshu,1);y1left=zeros(geshu,1);z1left=zeros(geshu,1);changleft=zeros(geshu,1);
x2left=zeros(geshu,1);y2left=zeros(geshu,1);z2left=zeros(geshu,1);distleft=zeros(geshu,1);
x1right=zeros(geshu,1);y1right=zeros(geshu,1);z1right=zeros(geshu,1);changduright=zeros(geshu,1);
x2right=zeros(geshu,1);y2right=zeros(geshu,1);z2right=zeros(geshu,1);distright=zeros(geshu,1); 

dist=zeros(geshu,1);%dist是每个木条转轴处距离中轴线的距离
y1=zeros(geshu,1);
h1=zeros(geshu,1);
for i=1:geshu/2
    y1(i)=sd;
    sd=sd+dd;
end
if isjishu==0
      y1(geshu/2+1)=y1(geshu/2);
else
      y1(geshu/2+1)=y1(geshu/2)+dd;
end;
for i=geshu/2+2:geshu
    y1(i)=y1(i-1)+dd;
end;
y1=y1-R;
y2=y1;
for i=1:geshu
dist(i)=fx(y1(i),DD);
end;
changdu=zeros(geshu,1);
changdu(1)=H/sin(thita);
for i=1:geshu
    h1(i)=fx2(y1(i),y1(1));  %fx2 以接触地面为中心建标 不要建错了
end
l=namda*changdu(1);
qj=zeros(geshu,1);ta=zeros(geshu,1);
for i=2:geshu
    a=dist(i)-dist(1);
    qj(i)=sqrt(a^2+l^2-2*cos(thita)*a*l);
    ttt=(a^2+qj(i)^2-l^2)/(2*a*qj(i)); 
    ta(i)=acos(ttt);
    if abs(a)<=0.000001
        ta(i)=thita;
    end;
end;
ta(1)=pi-thita;
for i=1:geshu
changdu(i)=H/sin(ta(i))*(H-h1(i))/H; %s指的是活动长度
end;
x1=zeros(geshu,1);z1=zeros(geshu,1);
x1=dist;xx=dist;
thitaa=thita;
x=l*cos(thitaa)+dist(1);
z=l*sin(thitaa);
x2=zeros(geshu,1);
z2=zeros(geshu,1);
flag1=1;
for k=2:geshu-1;
if l+dist(1)<dist(k)
    flag1=2;
end;
if l+dist(1)>dist(k)+changdu(k)
      flag1=0;
     end;
end;
for j=1:geshu;
    qujian(i,j)=sqrt((x-xx(j))^2+z^2);
    if qujian(i,j)>changdu(j)+0.001
       flag1=3;
    end;
    z2(j)=changdu(j)/qujian(i,j)*z;
    x2(j)=xx(j)-(changdu(j)/qujian(i,j)*(xx(j)-x));
end

x1right=x1;y1right=y1;z1right=-z1;changduright=changdu;
x2right=x2;y2right=y2;z2right=-z2;distright=dist;lright=l; 

%% 左面


sd=dd/2;%注意这个变化了
dist=zeros(geshu,1);%dist是每个木条转轴处距离中轴线的距离
y1=zeros(geshu,1);
h1=zeros(geshu,1);
for i=1:geshu/2
    y1(i)=sd;
    sd=sd+dd;
end
if isjishu==0
      y1(geshu/2+1)=y1(geshu/2);
else
      y1(geshu/2+1)=y1(geshu/2)+dd;
end;
for i=geshu/2+2:geshu
    y1(i)=y1(i-1)+dd;
end;
y1=y1-R;
y2=y1;

  for i=1:geshu
    dist(i)=fxx(y1(i),DD);
  end;

changdu=zeros(geshu,1);
changdu(1)=H/sin(thita2);
sd=dd;
for i=1:geshu
    h1(i)=fx22(y1(i),y1(1));  %fx2 以接触地面为中心建标 不要建错了
end
l=namda2*changdu(1);
qj=zeros(geshu,1);ta=zeros(geshu,1);
for i=2:geshu
    a=dist(i)-dist(1);
    qj(i)=sqrt(a^2+l^2-2*cos(thita2)*a*l);
    ttt=(a^2+qj(i)^2-l^2)/(2*a*qj(i)); 
    ta(i)=acos(ttt);
    if abs(a)<=0.000001
        ta(i)=thita2;
    end;
end;
ta(1)=pi-thita2;
for i=1:geshu
changdu(i)=H/sin(ta(i))*(H-h1(i))/H;%s指的是活动长度
end;
x1=zeros(geshu,1);z1=zeros(geshu,1);
x1=dist;xx=dist;
thitaa=thita2;
x=l*cos(thitaa)+dist(1);
z=l*sin(thitaa);
x2=zeros(geshu,1);
z2=zeros(geshu,1);
flag2=1;

for k=2:geshu-1;
if l+dist(1)<dist(k)
    flag2=2;
end;
if l+dist(1)>dist(k)+changdu(k)
      flag2=0;
     end;
end;
for j=1:geshu;
    qujian(i,j)=sqrt((x-xx(j))^2+z^2);
    if qujian(i,j)>changdu(j)+0.001
       flag2=3;
    end;
    z2(j)=changdu(j)/qujian(i,j)*z;
    x2(j)=xx(j)-(changdu(j)/qujian(i,j)*(xx(j)-x));
end

x1=-x1;x2=-x2;
x=-x;


x1left=x1;y1left=y1;z1left=-z1;changduleft=changdu;
x2left=x2;y2left=y2;z2left=-z2;distleft=dist;lright=l; 


flag=1;
if flag1~=1 || flag2~=1
    flag=0;
end;

m=0;
for w=1:geshu
    m=m+changduleft(w)*dd*(H+0.5*z2left(w));
    m=m+changduright(w)*dd*(H+0.5*z2right(w));
end;
%if isjishu==0
       % m=m-changduleft(geshu/2)*dd*(H+0.5*z2left(geshu/2));
       % m=m-changduright(geshu/2)*dd*(H+0.5*z2right(geshu/2));
  %  end;
    
    
l1=max(changduleft+distleft);
r1=max(changduright+distright);

end

