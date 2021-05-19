% ����ģ���˻��㷨���㡰�������⡱
% �㷨�μ����ִ��Ż����㷽����P105
% author: wwb
% Date:2010-12-20

clear

%ԭ�ϳߴ�
RawMaterials = [400, 300];

%��Ʒ������������
nProductMaterials = 20;

%��Ʒ�ϵ����������
S0 = GetProductMaterials( RawMaterials, nProductMaterials );
%load S0.mat;

% ��س���

% �¶��½�����Lundy and Mess��ʽ�ӣ�������δ����
delta0 = 1;           %����f�Ķ���õ�
K = 10; 
t0 = K * delta0;    %��ʼ�¶�
tf = 10;
M = 50000;         %�ܵ�����������
beta = (t0-tf) / (M*t0*tf);

% �¶��½���һ�ַ������μ�P102
L = 200;                 %ͬһ�¶ȵ����������½�
U = 500;                %ͬһ�¶ȵ����������Ͻ�
AcceptRatio = 0.5;    %ͬһ�¶��µ������ܴ�������������ı�ֵ


S = S0;                 % ��ʼ��
iIter = 0;               % ͬһ�¶ȵĵ�������
nTotalIter = 0;      % �ܵ�������

k = 1;                    % ��ͬ�¶ȵĵ�������
ratio(k) = 1;           % ���ú����������������ϵı�ֵ
tk(1) = t0;              % �¶�ֵ
fbestratio = 1;        % ���ú�������Сֵ
Sbest = S;              % ���Ž�

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
         
         % ��ʵ���ü�¼���Ž⣬���¶��½�������ʱ��ĳ��ĳ��ָ�����󣨽ӽ�1������ý�Ϊ���Ž�
         if fS < fbestratio
             fbestratio = fS;
             Sbest = S;
         end
         
         iIter = iIter + 1;
         nTotalIter = nTotalIter + 1;
         
         if ( iIter > L && iAcceptIter/iIter > AcceptRatio )
             fprintf('iAcceptIter/iIter = %f\n', iAcceptIter/iIter);
             break;              %�¶ȿ�ʼ�½�
         end
   
    end
    
    ratio(k) = f(S, RawMaterials, false);
    
    fprintf('iOuterLoop = %d, iIter = %d, tk = %f, ratio = %f, fbestratio=%f\n', k, iIter, tk(k), ratio(k), fbestratio);
     
    %tk(k+1) = tk(k) / ( 1+beta*tk(k) );
    %�¶��½��ķ���
    tk(k+1) = 0.9 * tk(k); 
    
    k = k + 1;
    
end

fbestratio = f(Sbest, RawMaterials, true);
fprintf('best ratio = %f, nTotalIter = %d\n', fbestratio, nTotalIter);

Sbest


