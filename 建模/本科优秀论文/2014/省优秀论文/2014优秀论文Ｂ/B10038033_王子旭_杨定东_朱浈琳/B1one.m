
sd=1.25;R=25;dd=2.5;
dist=zeros(20,1);%dist是每个木条转轴处距离中轴线的距离
z1=zeros(20,1);
for i=1:10
    z1(i)=sd;
    dist(10-i+1)=sqrt(R^2-sd^2);
    sd=sd+dd;
end
for i=11:20
    z1(i)=z1(i-1)+dd;
end;
z2=z1;
z1=z1-25;z2=z2-25;
%60-dist   %是每根木条的长度
xx=zeros(20,1);%xx是距离第一条转轴长度即各个木条的横坐标
xx=dist;
changdu=60-dist;
qujian=zeros(7,10);
x1=zeros(20,1);y1=zeros(20,1);
x1=dist;
l=0.5*(60-dist(1));

for i=1:7;
    figure
du=90-16.6709;
thitaa=i*10;
thita=thitaa/180*pi;
x=l*cos(thita)+dist(1);
y=l*sin(thita);
x2=zeros(20,1);
y2=zeros(20,1);
for j=1:10;
    qujian(i,j)=sqrt((x-xx(j))^2+y^2);
    y2(j)=changdu(j)/qujian(i,j)*y;
    x2(j)=xx(j)-(changdu(j)/qujian(i,j)*(xx(j)-x));
end

for ii=11:20
    x1(ii)=x1(20-ii+1);
    x2(ii)=x2(20-ii+1);
    y1(ii)=y1(20-ii+1);
    y2(ii)=y2(20-ii+1);
end;

set(gca,'XTick',[-60:20:60]);
set(gca,'YTick',[-30:20:30]);
set(gca,'ZTick',[-50:10:0]);
xlim([-60,60]);
ylim([-30,30]);
zlim([-50,0]);
for j=1:20
 hold on
line([x1(j);x2(j)],[z1(j),z2(j)],[-y1(j);-y2(j)],'LineWidth',2);
plot3(x1(j),z1(j),-y1(j),'.k');
plot3(x2(j),z2(j),-y2(j),'*r');
end;
for j=1:20
line([-x1(j);-x2(j)],[z1(j),z2(j)],[-y1(j);-y2(j)],'LineWidth',2);
plot3(-x1(j),z1(j),-y1(j),'.k');
plot3(-x2(j),z2(j),-y2(j),'*r');
end;
line([x;x],[z1(1);-z1(1)],[-y;-y],'LineWidth',3,'color','k');
line([-x;-x],[z1(1);-z1(1)],[-y;-y],'LineWidth',3,'color','k');
plot3(x2,z2,-y2);
plot3(-x2,z1,-y2);
R = 25; r = 0;  
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
title(['θ=',num2str(i*10),'°']);
hold off
end;

qujian(i,:)+dist(1:10)'-(dist(1)+l)