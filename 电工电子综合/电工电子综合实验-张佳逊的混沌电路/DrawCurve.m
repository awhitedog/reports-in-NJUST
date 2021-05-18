file='';

load(strcat('ccc',file,'.mat'));
Il1=Il1./10;
f=figure(1);
subplot(2,2,1);
plot3(Uc1,Uc2,Il1);
hold on;
xlabel('Uc1 (V)');
hold on;
ylabel('Uc2 (V)');
hold on;
zlabel('Il1 (A)');
hold on;
grid on;

subplot(2,2,2);
plot(Uc1,Uc2);
hold on;
xlabel('Uc1 (V)');
hold on;
ylabel('Uc2 (V)');
hold on;
grid on;

subplot(2,2,3);
plot(Uc1,Il1);
hold on;
xlabel('Uc1 (V)');
hold on;
ylabel('Il1 (A)');
hold on;
grid on;

subplot(2,2,4);
plot(Uc2,Il1);
hold on;
xlabel('Uc2 (V)');
hold on;
ylabel('Il1 (A)');
hold on;
grid on;

scrsz = get(0,'ScreenSize');
set(f,'Position',scrsz);
saveas(f,strcat('ccc',file),'fig');
saveas(f,strcat('ccc',file),'bmp');
clear file
clear f
clear scrsz
clear