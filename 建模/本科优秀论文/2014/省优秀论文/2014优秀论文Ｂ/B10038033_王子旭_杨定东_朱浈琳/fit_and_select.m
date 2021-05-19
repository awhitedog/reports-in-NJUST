function fitness=fit_and_select(L,h,n,lamda)
% ��Ӧ�Ȳ���ɸѡ
% �����ϵĻ���fitness����ʾ ����-inf
% l0����������ĵĳ��ȣ�x��1����������Ŀ�϶��

% ����ֵ 
% l0  ��theta�Ǹ��ٽ�ֵ����ʾ��D0��֪��ľ���ܳ� l0+x(1)
% h   �ڹ̶�[3,5]֮������
% n   ��[20,30]֮������
% lg  ��(0,1)֮��ֽ��λ��
tho=6e-4;% ľ���ܶȴ�Լ6e-4kgÿ��������
miu=0.5; % ľ��Ķ�Ħ��ϵ��
H0=70;
D0=80;
% n=20;   
d=80./n;
me=45;    % �����������kg


xi=@(i)power((D0*D0/4-(D0/2-(i-0.5)*d).^(2)),0.5);% �����ļ��
% arctan(2) �����ٽ�ֵ�ǣ������ƣ�1.1071
l0=L/2-xi(1);
lg=l0*lamda;

theta=asin((H0-h)./l0);
if ~isreal(theta)
   fitness=-inf;
   return  
end

% ����������
M=(l0+xi(1))*2*D0*h*tho;
% ����ľ�ĵ�����
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
% L=2*(l0+x(1));% ���ܳ�
g=10; % �������ٶ�


flag=okornot(D0,H0,L,n,lamda,h);
% okornot( DD,H,bianchang,geshu,namda,houdu )
% �����������������ҷ��ϲ۵���������
if  cot(theta)<=(M+me/(2*(m_r+me)))&&...
        (M+me)*g*l0*cos(theta)<4*m_x(1)*g*l0/2*cos(theta)+4*sum(m_x(2:end))*g*lg*cos(theta)+(M+me)*miu*g*l0*sin(theta)&&...
        flag
    %heavy_point=abs(zhixin); % ������һ��������Խ����ʾ
    V=h*(l0+x(1));%*2*D0�����������������ĳ�����ȥ
    fitness=1/V;
else
    fitness=-inf;
end


