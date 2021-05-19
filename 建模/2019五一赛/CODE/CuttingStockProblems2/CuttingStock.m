clear
board_size = [3000, 1500];
%Primitive arrangement of product dimensions
S0=zeros(60*2+48*2+35*2+64*2,2);
for i=1:60
    S0(i,1)=373;
    S0(i+60,1)=201;
    S0(i,2)=201;
    S0(i+60,2)=373;
end
% for i=60*2+1:1:60*2+48
%     S0(i,1)=406;
%     S0(i+48,1)=229;
%     S0(i,2)=229;
%     S0(i+48,2)=406;
% end

% for i=60*2+48*2+1:1:60*2+48*2+35
%     S0(i,1)=477;
%     S0(i+35,1)=282;
%     S0(i,2)=282;
%     S0(i+35,2)=477;
% end

% for i=60*2+48*2+35*2+1:1:60*2+48*2+35*2+64
%     S0(i,1)=311;
%     S0(i+64,1)=225;
%     S0(i,2)=225;
%     S0(i+64,2)=311;
% end


% constants

% Temperature drop using Lundy and Mess formula
d_0 = 1;           %According to the definition of f
K = 10; 
t0 = K * d_0;    %initial temperature
tf = 10;
M = 50000;         %Upper limit of total iteration times
beta = (t0-tf) / (M*t0*tf);

% 
L = 200;                 %Lower bound of iteration times at the same temperature
U = 500;                %The Upper Bound of iteration times at the Same Temperature
Accept_Ratio = 0.5;    
%Ratio of the number of iterations accepted to the number of iterations at the same temperature


S = S0;                 % Initial solution
i_Iter = 2;               % times of iterations at the same temperature
nTotal_Iter = 0;      % Total times of iterations

k = 1;                    % times of iterations at different temperatures
ratio(k) = 1;           % Cost function: ratio of surplus to total consumption
tk(1) = t0;              % Temperature
fmin = 1;        % Minimum Cost Function
solution = S;              % optimum solution

while( nTotal_Iter<M && fmin > 0.02  ) 
    
    i_Iter = 0;
    iAccept_Iter = 0;
    fS = f( S, board_size, false );
    while ( i_Iter<U )
    
         Sstar = N( S );
         df = 0;
         fStar = f( Sstar, board_size, false);
         df = fStar - fS;
    
         if ( df <=0 || exp( -df / tk(k) ) > rand )
             S = Sstar;
             fS = fStar;
             iAccept_Iter = iAccept_Iter + 1;
         end     
         
         % When the temperature drops to the limit
         if fS < fmin
             fmin = fS;
             solution = S;
         end
         
         i_Iter = i_Iter + 1;
         nTotal_Iter = nTotal_Iter + 1;
         
         if ( i_Iter > L && iAccept_Iter/i_Iter > Accept_Ratio )
             fprintf('iAcceptIter/iIter = %f\n', iAccept_Iter/i_Iter);
             break;              %Temperature drop
         end
   
    end
    
    ratio(k) = f(S, board_size, false);
    
    fprintf('iOuterLoop = %d, iIter = %d, tk = %f, ratio = %f, fbestratio=%f\n', k, i_Iter, tk(k), ratio(k), fmin);
     
    %tk(k+1) = tk(k) / ( 1+beta*tk(k) );
    %Temperature drop
    tk(k+1) = 0.9 * tk(k); 
    
    k = k + 1;
    
end

fmin = f(solution, board_size, true);
fprintf('best ratio = %f, nTotalIter = %d\n', fmin, nTotal_Iter);


