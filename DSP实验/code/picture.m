clc,clear;
a = 1:1:6; %������
b = [8.0 9.0 10.0 15.0 35.0 40.0]; %������
plot(a, b, 'b'); %��Ȼ״̬�Ļ�ͼЧ��
hold on;
%��һ�֣���ƽ�����ߵķ���
c = polyfit(a, b, 2);  %������ϣ�cΪ2����Ϻ��ϵ��
d = polyval(c, a, 1);  %��Ϻ�ÿһ���������Ӧ��ֵ��Ϊd
plot(a, d, 'r');  %��Ϻ������

plot(a, b, '*');  %��ÿ���� ��*������
hold on;
%�ڶ��֣���ƽ�����ߵķ���
values = spcrv([[a(1) a a(end)];[b(1) b b(end)]],3);
plot(values(1,:),values(2,:), 'g');

legend('1','2','3');
grid on;