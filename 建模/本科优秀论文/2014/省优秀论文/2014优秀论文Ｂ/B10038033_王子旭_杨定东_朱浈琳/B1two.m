
clear;clc;
x0=15.2928;
z0=-25;
for l=0:0.1:25
hold on
D=sqrt((x0-l)^2+z0^2);
x=l-(60-l)/D*(l-x0);
y=sqrt(25^2-l^2);
z=(60-l)/D*z0;
plot3(x,y,z);
end;
for l=25:-0.1:0
    
D=sqrt((x0-l)^2+z0^2);
x=l-(60-l)/D*(l-x0);
y=sqrt(25^2-l^2);
z=(60-l)/D*z0;
plot3(x,-y,z);
end;
xlabel('x');
ylabel('y');
zlabel('z');
view(61,20);