function [S0] = GetProductMaterials( RawMaterials, nProductMaterials )
% 随机产生产品料集合
% input：RawMaterials，原料的长宽；nProductMaterials，产品料的数目
% output：S0，产品料集合
   for i=1:1:nProductMaterials
       x = randint(1, 1 , [RawMaterials(1)/10, RawMaterials(1)/2]);
       y = randint(1, 1 , [RawMaterials(1)/10, RawMaterials(2)/3]);
       S0(i, :) = [x, y];
   end
end