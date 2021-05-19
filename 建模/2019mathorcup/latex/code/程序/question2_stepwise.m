
%---------------- Empty the workspace ----------------%
clearvars -except D1 D2 coefficient Optimized_coefficient;
clc;

%---------------- Initial parameter ----------------%
element = 'Si';

%---------------- Read data ----------------%
str = {'C', 'Mn', 'S', 'P', 'Si'};
tr = strcmp(element, str);
range_line_group = [810 251 810 251 810];
element_id_group = [1 2 3 4 5];
range_line = sum(range_line_group.*tr);
element_id = sum(element_id_group.*tr);

weight_of_molten_steel = D1(1:range_line, 10);
element_content_before = D1(1:range_line, element_id+4);
element_content_after = D1(1:range_line, element_id+10);
elemental_quality = 0;
for i=1:16
    elemental_quality = elemental_quality+D1(1:range_line, 28+i).*D2(i, element_id);
end

temperature             =   D1(1:range_line, 4);
initial_value           =   D1(1:range_line, 5:9);
initial_value           =   initial_value.*weight_of_molten_steel;
input_material          =   D1(1:range_line, 29:44);

%---------------- Data preprocessing ----------------%
historical_income_rate = weight_of_molten_steel.*(element_content_after-element_content_before)./elemental_quality;
factor_mat = [temperature, initial_value, weight_of_molten_steel, input_material];

preprocess_mat = data_preprocessing(historical_income_rate, factor_mat);
% historical_income_rate = preprocess_mat(:, 1);
% factor_mat = preprocess_mat(:, 2:end); 
% preprocess_mat_new = [preprocess_mat, preprocess_mat(:, 2:end).^2];

%---------------- Stepwise planning ----------------%
% stepwise(factor_mat, historical_income_rate);
stepwise(preprocess_mat(:, 2:end), preprocess_mat(:, 1));
% stepwise(preprocess_mat_new(:, 2:end), preprocess_mat_new(:, 1));


