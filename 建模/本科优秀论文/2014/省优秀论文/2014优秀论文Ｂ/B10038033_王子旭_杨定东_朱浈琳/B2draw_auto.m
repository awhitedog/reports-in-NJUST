clear;

DD=80;R=DD/2;geshu=30;H=70;namda=0.449859;houdu=3.001066;
dd=DD/geshu;sd=dd/2;bianchang=156.9455;

H=H-houdu;
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
    flag=0
end;
for j=1:geshu/2;
    qujian(i,j)=sqrt((x-xx(j))^2+y^2);
    if qujian(i,j)>changdu(j)
       flag=2;
    end;
    y2(j)=changdu(j)/qujian(i,j)*y;
    x2(j)=xx(j)-(changdu(j)/qujian(i,j)*(xx(j)-x));
    if x2(j)<0
        flag=0;
    end;
end

for j=1:geshu/2

  qujian(i,j)+dist(j)-(dist(1)+l);

end;

for ii=geshu/2+1:geshu
    x1(ii)=x1(geshu-ii+1);
    x2(ii)=x2(geshu-ii+1);
    y1(ii)=y1(geshu-ii+1);
    y2(ii)=y2(geshu-ii+1);
end;

figure
set(gca,'XTick',[-80:10:80]);
set(gca,'YTick',[-40:20:40]);
set(gca,'ZTick',[-70:10:0]);
xlim([-80,80]);
ylim([-40,40]);
zlim([-70,0]);
for j=1:geshu
 hold on
line([x1(j);x2(j)],[z1(j),z2(j)],[-y1(j);-y2(j)],'LineWidth',2);
plot3(x1(j),z1(j),-y1(j),'.k');
plot3(x2(j),z2(j),-y2(j),'*r');
end;
for j=1:geshu
line([-x1(j);-x2(j)],[z1(j),z2(j)],[-y1(j);-y2(j)],'LineWidth',2);
plot3(-x1(j),z1(j),-y1(j),'.k');
plot3(-x2(j),z2(j),-y2(j),'*r');
end;
line([x;x],[z1(1);-z1(1)],[-y;-y],'LineWidth',3,'color','k');
line([-x;-x],[z1(1);-z1(1)],[-y;-y],'LineWidth',3,'color','k');
plot3(x2,z2,-y2);
plot3(-x2,z1,-y2);

r = 0;  
theta=linspace(0,2*pi,90);
ph=linspace(r,R,30); 
[t,p]=meshgrid(theta,ph);
r=t*0;  
[xe,ye,ze]=pol2cart(t,p,r); 
mesh(xe,ye,ze); 
axis equal;
xlabel('x');
ylabel('y');
zlabel('z');
view(21,20);
st='不可以';
if flag==1 
    st='可以';
end;
view(21,20);

title(['θ=',num2str(thita/pi*180),'°']);
hold off


%%

l=namda*(bianchang/2-dist(1));
x1=zeros(geshu,1);y1=zeros(geshu,1);
x1=dist;
for i=1:8

thita=(i-1)*10/180*pi;
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
       flag=2;
    end;
    y2(j)=changdu(j)/qujian(i,j)*y;
    x2(j)=xx(j)-(changdu(j)/qujian(i,j)*(xx(j)-x));
    if x2(j)<0
        flag=0;
    end;
end

for ii=geshu/2+1:geshu
    x1(ii)=x1(geshu-ii+1);
    x2(ii)=x2(geshu-ii+1);
    y1(ii)=y1(geshu-ii+1);
    y2(ii)=y2(geshu-ii+1);
end;
%
 %subplot(2,2,i-4);
 figure

set(gca,'XTick',[-80:10:80]);
set(gca,'YTick',[-40:20:40]);
set(gca,'ZTick',[-70:10:0]);
xlim([-80,80]);
ylim([-40,40]);
zlim([-70,0]);
for j=1:geshu
 hold on
line([x1(j);x2(j)],[z1(j),z2(j)],[-y1(j);-y2(j)],'LineWidth',2);
plot3(x1(j),z1(j),-y1(j),'.k');
plot3(x2(j),z2(j),-y2(j),'*r');
end;
for j=1:geshu
line([-x1(j);-x2(j)],[z1(j),z2(j)],[-y1(j);-y2(j)],'LineWidth',2);
plot3(-x1(j),z1(j),-y1(j),'.k');
plot3(-x2(j),z2(j),-y2(j),'*r');
end;
line([x;x],[z1(1);-z1(1)],[-y;-y],'LineWidth',3,'color','k');
line([-x;-x],[z1(1);-z1(1)],[-y;-y],'LineWidth',3,'color','k');
plot3(x2,z2,-y2);
plot3(-x2,z1,-y2);

r = 0;  
theta=linspace(0,2*pi,90);
ph=linspace(r,R,30); 
[t,p]=meshgrid(theta,ph);
r=t*0;  
[xe,ye,ze]=pol2cart(t,p,r); 
mesh(xe,ye,ze); 
axis equal;
xlabel('x');
ylabel('y');
zlabel('z');
view(21,20);
st='不可以';
if flag==1 
    st='可以';
end;

title(['θ=',num2str((i-1)*10),'°']);


hold off

end;
