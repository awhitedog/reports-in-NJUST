function fitness=fit_and_select2(theta1,theta2,h,n,lamda1,lamda2)
% ��Ӧ�Ȳ���ɸѡ
% �����ϵĻ���fitness����ʾ ����-inf
% l0����������ĵĳ��ȣ�x��1����������Ŀ�϶��
% xxxx1��ʾ��� xxxx2��ʾ�ұ�
global H0 D0


% ����ֵ 
% l0  ��theta�Ǹ��ٽ�ֵ����ʾ��D0��֪��ľ���ܳ� l0+x(1)
% h   �ڹ̶�[3,5]֮������
% n   ��[20,30]֮������
% lg  ��(0,1)֮��ֽ��λ��

[flag,~,changduleft,changduright,~,~,l1,lr] = B3okornot(D0,H0,n,h,lamda1,lamda2,theta1,theta2);

tho=6e-4;% ľ���ܶȴ�Լ6e-4kgÿ��������
miu=0.5; % ľ��Ķ�Ħ��ϵ��
% n=20;   
d=D0./n;
me=45;    % �����������kg

%%

lg1=(changduleft(1))*lamda1;
lg2=(changduright(1))*lamda2;

% ����������
M=(l1+lr)*D0*h*tho;
L=l1+lr;
% ���������
m_r=M-(sum(changduleft)+sum(changduright))*tho*d*h;
 g=10; % �������ٶ�

m_left=sum(changduleft(1:end))*d*tho*h;    %��߿ɻ���ȵ�����
m_right=sum(changduright(1:end))*d*tho*h;  %�ұ߿ɻ׿���ȵ�������
F1=(m_r+me)*g*(cos(theta1)/(sin(theta1)*cos(theta2)+sin(theta2)*cos(theta1)))/2;  % ����������ȵ�����������
F2=(m_r+me)*g*(cos(theta2)/(sin(theta1)*cos(theta2)+sin(theta2)*cos(theta1)))/2;  % �����ұ����ȵ�����������
N1=(F1*sin(theta1)+m_left*g/2);      % ����ȵ���֧����
N2=(F2*sin(theta2)+m_right*g/2);     % �ұ��ȵ�֧����
% �����������������ҷ��ϲ۵���������
if  flag&&...
       N1/2>=F1*cos(theta1)&&...
       N2/2>=F2*cos(theta2)&&... % ��������
       N1*changduleft(1)*cos(theta1)<changduleft(1)*changduleft(1)*d*h*tho*g*cos(theta1)/2+sum(changduleft(2:end-1))*tho*d*h*g/2*lg1*cos(theta1)+N1/2*changduleft(1)*sin(theta1)&&...
       N2*changduright(2)*cos(theta2)<changduright(2)*changduright(2)*d*h*tho*g*cos(theta2)/2+sum(changduright(2:end-1))*tho*d*h*g/2*lg2*cos(theta1)+N2/2*changduright(1)*sin(theta2)
   % ���߶�Ҫ������������
   
    V=h*L;      %*2*D0�����������������ĳ�����ȥ
    fitness=1/V;
else
    fitness=-inf;
end


