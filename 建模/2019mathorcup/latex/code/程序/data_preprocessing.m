function [ output_args ] = data_preprocessing( mat_pro, factor_mat )
% data_preprocessing:
% Remove values from the array that are less than zero and
% greater than one
%   Need to enter the matrix to be processed 
%   and the related factor matrix as parameters
    mat_new = ones(1,1);
    factor_mat_new = ones(1,23);
    k = 1;
    for i = 1:length(mat_pro)
        if mat_pro(i)>0 && mat_pro(i)<=1
            mat_new(k,1) = mat_pro(i);
            factor_mat_new(k,:) = factor_mat(i, :);
            k = k+1;
        end
    end
    
%     output_args = factor_mat;
    
    output_args = [mat_new, factor_mat_new];

end

