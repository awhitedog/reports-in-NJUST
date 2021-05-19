function [S0] = GetProductMaterials( RawMaterials, nProductMaterials )
% ���������Ʒ�ϼ���
% input��RawMaterials��ԭ�ϵĳ���nProductMaterials����Ʒ�ϵ���Ŀ
% output��S0����Ʒ�ϼ���
   for i=1:1:nProductMaterials
       x = randint(1, 1 , [RawMaterials(1)/10, RawMaterials(1)/2]);
       y = randint(1, 1 , [RawMaterials(1)/10, RawMaterials(2)/3]);
       S0(i, :) = [x, y];
   end
end