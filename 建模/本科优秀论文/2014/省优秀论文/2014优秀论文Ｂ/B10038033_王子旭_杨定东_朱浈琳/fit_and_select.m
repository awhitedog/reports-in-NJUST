function fitness=fit_and_select(L,h,n,lamda)
% 适应度并且筛选
% 不符合的会在fitness处显示 返回-inf
% l0代表最外层板材的长度，x（1）代表最初的空隙，

% 待赋值 
% l0  由theta那个临界值给启示，D0已知；木板总长 l0+x(1)
% h   在固定[3,5]之间搜索
% n   在[20,30]之间搜索
% lg  在(0,1)之间钢筋的位置
tho=6e-4;% 木材密度大约6e-4kg每立方厘米
miu=0.5; % 木板的动摩擦系数
H0=70;
D0=80;
% n=20;   
d=80./n;
me=45;    % 载重物的质量kg


xi=@(i)power((D0*D0/4-(D0/2-(i-0.5)*d).^(2)),0.5);% 到中心间距
% arctan(2) 就是临界值是（弧度制）1.1071
l0=L/2-xi(1);
lg=l0*lamda;

theta=asin((H0-h)./l0);
if ~isreal(theta)
   fitness=-inf;
   return  
end

% 整块板材质量
M=(l0+xi(1))*2*D0*h*tho;
% 所有木材的质量
if (n/2)==ceil(n/2)
   x=xi(1:n/2);
   %lx=(l0+xi(1)-x);
   m_x=(l0+xi(1)-x)*d*tho*h;
   m_r=M-sum(m_x*4);
else
   x=xi(1:ceil(n/2));
   m_x=(l0+xi(1)-x)*d*tho*h;
   %lx=(l0+xi(1)-x);
   m_x(end)=m_x(end)/2;
   m_r=M-sum(m_x*4);
end
% L=2*(l0+x(1));% 板总长
g=10; % 重力加速度


flag=okornot(D0,H0,L,n,lamda,h);
% okornot( DD,H,bianchang,geshu,namda,houdu )
% 符合条件载重条件且符合槽的制作条件
if  cot(theta)<=(M+me/(2*(m_r+me)))&&...
        (M+me)*g*l0*cos(theta)<4*m_x(1)*g*l0/2*cos(theta)+4*sum(m_x(2:end))*g*lg*cos(theta)+(M+me)*miu*g*l0*sin(theta)&&...
        flag
    %heavy_point=abs(zhixin); % 质心是一个负数，越负表示
    V=h*(l0+x(1));%*2*D0后面是两个乘起来的常数略去
    fitness=1/V;
else
    fitness=-inf;
end


