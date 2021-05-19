% 利用模拟退火算法计算“下料问题”
% 算法参见《现代优化计算方法》P105
% author: wwb
% Date:2010-12-20

clear

%原料尺寸
RawMaterials = [400, 300];

%产品料数量及种类
nProductMaterials = 20;

%产品料的随机数据组
S0 = GetProductMaterials( RawMaterials, nProductMaterials );
%load S0.mat;

% 相关常数

% 温度下降采用Lundy and Mess的式子，本文暂未采用
delta0 = 1;           %根据f的定义得到
K = 10; 
t0 = K * delta0;    %初始温度
tf = 10;
M = 50000;         %总迭代次数上限
beta = (t0-tf) / (M*t0*tf);

% 温度下降的一种方法，参见P102
L = 200;                 %同一温度迭代次数的下界
U = 500;                %同一温度迭代次数的上界
AcceptRatio = 0.5;    %同一温度下迭代接受次数与迭代次数的比值


S = S0;                 % 初始解
iIter = 0;               % 同一温度的迭代次数
nTotalIter = 0;      % 总迭代次数

k = 1;                    % 不同温度的迭代次数
ratio(k) = 1;           % 费用函数：余料与总用料的比值
tk(1) = t0;              % 温度值
fbestratio = 1;        % 费用函数的最小值
Sbest = S;              % 最优解

while( nTotalIter<M && fbestratio > 0.02  ) 
    
    iIter = 0;
    iAcceptIter = 0;
    fS = f( S, RawMaterials, false );
    while ( iIter<U )
    
         Sstar = N( S );
         deltaf = 0;
         fStar = f( Sstar, RawMaterials, false);
         deltaf = fStar - fS;
    
         if ( deltaf <=0 || exp( -deltaf / tk(k) ) > rand )
             S = Sstar;
             fS = fStar;
             iAcceptIter = iAcceptIter + 1;
         end     
         
         % 其实不用记录最优解，当温度下降到极限时，某解的出现概率最大（接近1），则该解为最优解
         if fS < fbestratio
             fbestratio = fS;
             Sbest = S;
         end
         
         iIter = iIter + 1;
         nTotalIter = nTotalIter + 1;
         
         if ( iIter > L && iAcceptIter/iIter > AcceptRatio )
             fprintf('iAcceptIter/iIter = %f\n', iAcceptIter/iIter);
             break;              %温度开始下降
         end
   
    end
    
    ratio(k) = f(S, RawMaterials, false);
    
    fprintf('iOuterLoop = %d, iIter = %d, tk = %f, ratio = %f, fbestratio=%f\n', k, iIter, tk(k), ratio(k), fbestratio);
     
    %tk(k+1) = tk(k) / ( 1+beta*tk(k) );
    %温度下降的方法
    tk(k+1) = 0.9 * tk(k); 
    
    k = k + 1;
    
end

fbestratio = f(Sbest, RawMaterials, true);
fprintf('best ratio = %f, nTotalIter = %d\n', fbestratio, nTotalIter);

Sbest


