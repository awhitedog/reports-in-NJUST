clear;
%由用户给出 注意还没有减去houdu;
% 本次确定钢筋的位置从最能够使得桌子建成的角度出发，也是可以自己设定的
DD=40;
R=DD/2;geshu=20;H=53;houdu=3.002698;H=H-houdu;
dd=DD/geshu;sd=dd/2;sd1=sd;
namda=0.526183;namda2=0.488829;
thita=1.289534;thita2=1.2387;

isjishu=1;
if mod(geshu,2)==1   
    geshu=geshu+1;
    isjishu=0;
end;

figure

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
changdu(i)=H/sin(ta(i))*(H-h1(i))/H;
changdu(i)%s指的是活动长度
end;
x1=zeros(geshu,1);z1=zeros(geshu,1);
x1=dist;xx=dist;
thitaa=thita;
x=l*cos(thitaa)+dist(1);
z=l*sin(thitaa);
x2=zeros(geshu,1);
z2=zeros(geshu,1);
flag1=1;
for k=2:geshu/2;
if l+dist(1)<dist(k)
    flag1=2;
end;
if l+dist(1)>dist(k)+changdu(k)
      flag1=0;
     end;
end;
for j=1:geshu;
    qujian(j)=sqrt((x-xx(j))^2+z^2);
    if qujian(j)>changdu(j)+0.001
       flag1=3;
    end;
    z2(j)=changdu(j)/qujian(j)*z;
    x2(j)=xx(j)-(changdu(j)/qujian(j)*(xx(j)-x));
end

hold on

for j=1:geshu
line([x1(j);x2(j)],[y1(j),y2(j)],[-z1(j);-z2(j)],'LineWidth',2);
plot3(x1(j),y1(j),-z1(j),'.k');
plot3(x2(j),y2(j),-z2(j),'*r');
end;

line([x;x],[y1(1);y1(geshu)],[-z;-z],'LineWidth',3,'color','k');

x1right=x1;y1right=y1;z1right=-z1;changduright=changdu;
x2right=x2;y2right=y2;z2right=-z2;distright=dist;lright=l; 
kaizaoright=zeros(geshu,0);
kaizaoright=qujian'+dist-(dist(1)+l)

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


for k=2:geshu/2;
if l+dist(1)<dist(k)
    flag2=2;
end;
if l+dist(1)>dist(k)+changdu(k)
      flag2=0;
     end;
end;
for j=1:geshu;
    qujian(j)=sqrt((x-xx(j))^2+z^2);
    if qujian(j)>changdu(j)+0.001
       flag2=3;
    end;
    z2(j)=changdu(j)/qujian(j)*z;
    x2(j)=xx(j)-(changdu(j)/qujian(j)*(xx(j)-x));
end

x1=-x1;x2=-x2;
x=-x;


for j=1:geshu
line([x1(j);x2(j)],[y1(j),y2(j)],[-z1(j);-z2(j)],'LineWidth',2);
plot3(x1(j),y1(j),-z1(j),'.k');
plot3(x2(j),y2(j),-z2(j),'*r');
end;
line([x;x],[y1(1);y1(geshu)],[-z;-z],'LineWidth',3,'color','k');


x1left=x1;y1left=y1;z1left=-z1;changduleft=changdu;
x2left=x2;y2left=y2;z2left=-z2;distleft=dist;lleft=l; 
kaizaoleft=zeros(geshu,0);
kaizaoleft=qujian'+dist-(dist(1)+l)
for p=1:geshu
     q=p;
        line([x1left(p);x1right(q)],[y1left(p);y1right(q)],[0;0],'LineWidth',8,'color','k'); 
 end;


ul=ceil(max(changduleft+distleft)/10)*10;
ur=ceil(max(changduright+distright)/10)*10;
set(gca,'XTick',-ul:20:ur);
set(gca,'yTick',-R:10:R);
set(gca,'zTick',-ceil(H/10)*10:10:0);
xlim([-ul,ur]);
ylim([-R,R]);
zlim([-ceil(H/10)*10,0]);
axis equal;
xlabel('x');
zlabel('z');
ylabel('y');
view(21,20);
st='可以';
if flag1~=1 || flag2~=1
    st='不可以';
end;
title(['θ2=',num2str(thita/pi*180),'°',',θ1=',num2str(thita2/pi*180),'°']);
hold off
m=0;
for w=1:geshu
    m=m+changduleft(w)*dd*(H+0.5*z2left(w));
    m=m+changduright(w)*dd*(H+0.5*z2right(w));
end;
if isjishu==0
        m=m-changduleft(geshu/2)*dd*(H+0.5*z2left(geshu/2));
        m=m-changduright(geshu/2)*dd*(H+0.5*z2right(geshu/2));
    end;
l1=max(changduleft+distleft);
r1=max(changduright+distright);





