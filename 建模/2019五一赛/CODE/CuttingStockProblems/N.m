function [Sstar] = N( S )
% 产生解的邻域
% input：S，初始解。
% output：Sstar，初始解的邻域中随机挑选的一个解。

    nNum = max(size(S(:,1)));
    
    Sstar = zeros(nNum, 2);
    Sstar = S;
    
    index = zeros(1,2);
   
    index = randint(1, 2 , [1, nNum]);
    if index(1) == index(2)                   %自身也是其邻域内的状态值
        return;
    end
    
    Sstar( index(1), : ) = S( index(2), : );
    Sstar( index(2), : ) = S( index(1), : );
    
end