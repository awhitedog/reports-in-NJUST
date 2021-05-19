function [ output_args ] = data_preprocessing( mat_pro, factor_mat )
% data_preprocessing:
% Remove values from the array that are less than zero and
% greater than one
%   Need to enter the matrix to be processed 
%   and the related factor matrix as parameters
    for i = 1:length(mat_pro)
        try
            if mat_pro(i)<0 || mat_pro(i)>=1
                mat_pro(i) = [];
                factor_mat(i, :) = [];
            end
        catch
            break;
        end
    end
    
%     output_args = factor_mat;
    
    output_args = [mat_pro, factor_mat];

end

