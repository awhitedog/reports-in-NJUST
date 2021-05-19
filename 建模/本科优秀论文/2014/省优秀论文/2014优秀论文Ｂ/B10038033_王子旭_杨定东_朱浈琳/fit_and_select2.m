function fitness=fit_and_select2(theta1,theta2,h,n,lamda1,lamda2)
% 适应度并且筛选
% 不符合的会在fitness处显示 返回-inf
% l0代表最外层板材的长度，x（1）代表最初的空隙，
% xxxx1表示左边 xxxx2表示右边
global H0 D0


% 待赋值 
% l0  由theta那个临界值给启示，D0已知；木板总长 l0+x(1)
% h   在固定[3,5]之间搜索
% n   在[20,30]之间搜索
% lg  在(0,1)之间钢筋的位置

[flag,~,changduleft,changduright,~,~,l1,lr] = B3okornot(D0,H0,n,h,lamda1,lamda2,theta1,theta2);

tho=6e-4;% 木材密度大约6e-4kg每立方厘米
miu=0.5; % 木板的动摩擦系数
% n=20;   
d=D0./n;
me=45;    % 载重物的质量kg

%%

lg1=(changduleft(1))*lamda1;
lg2=(changduright(1))*lamda2;

% 整块板材质量
M=(l1+lr)*D0*h*tho;
L=l1+lr;
% 桌面的质量
m_r=M-(sum(changduleft)+sum(changduright))*tho*d*h;
 g=10; % 重力加速度

m_left=sum(changduleft(1:end))*d*tho*h;    %左边可活动桌腿的质量
m_right=sum(changduright(1:end))*d*tho*h;  %右边可活动卓桌腿的质量；
F1=(m_r+me)*g*(cos(theta1)/(sin(theta1)*cos(theta2)+sin(theta2)*cos(theta1)))/2;  % 计算左边桌腿的沿腿作用力
F2=(m_r+me)*g*(cos(theta2)/(sin(theta1)*cos(theta2)+sin(theta2)*cos(theta1)))/2;  % 计算右边桌腿的沿腿作用力
N1=(F1*sin(theta1)+m_left*g/2);      % 左边腿的受支持力
N2=(F2*sin(theta2)+m_right*g/2);     % 右边腿的支持力
% 符合条件载重条件且符合槽的制作条件
if  flag&&...
       N1/2>=F1*cos(theta1)&&...
       N2/2>=F2*cos(theta2)&&... % 受力方程
       N1*changduleft(1)*cos(theta1)<changduleft(1)*changduleft(1)*d*h*tho*g*cos(theta1)/2+sum(changduleft(2:end-1))*tho*d*h*g/2*lg1*cos(theta1)+N1/2*changduleft(1)*sin(theta1)&&...
       N2*changduright(2)*cos(theta2)<changduright(2)*changduright(2)*d*h*tho*g*cos(theta2)/2+sum(changduright(2:end-1))*tho*d*h*g/2*lg2*cos(theta1)+N2/2*changduright(1)*sin(theta2)
   % 两边都要满足受力方程
   
    V=h*L;      %*2*D0后面是两个乘起来的常数略去
    fitness=1/V;
else
    fitness=-inf;
end


