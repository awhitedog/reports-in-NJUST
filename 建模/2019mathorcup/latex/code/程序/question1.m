
element_C = read_data('C', D1, D2);
element_Mn = read_data('Mn', D1, D2);
historical_income_rate_C = element_C(:,1).*(element_C(:,3)-element_C(:,2))./element_C(:,4);
historical_income_rate_Mn = element_Mn(:,1).*(element_Mn(:,3)-element_Mn(:,2))./element_Mn(:,4);

factor_mat_C = factor('C', D1);
factor_mat_Mn = factor('Mn', D1);

preprocess_mat = data_preprocessing(historical_income_rate_C, factor_mat_C);
historical_income_rate_C = preprocess_mat(:, 1);
factor_mat_C = preprocess_mat(:, 2:end); 

% preprocess_mat = data_preprocessing(historical_income_rate_Mn, factor_mat_Mn);
% historical_income_rate_Mn = preprocess_mat(:, 1);
% factor_mat_Mn = preprocess_mat(:, 2:end);

% stepwise(factor_mat_C, historical_income_rate_C);
% stepwise(factor_mat_Mn, historical_income_rate_Mn);