element = 'C';
num = 100;
id = randperm(208, num);
if element == 'C'
    coefficient_matrix = [0.666421  1.35255e-05  -397.073  0  0  0  -10.0705  1.27e-05  0  0  0.00268162  0  0.00162781  0  -0.000820824  0  -0.000112861  0  0  -0.0038281  -1.10e-04  -0.000120863  -0.000307686  0];
    factor_mat_simulation = factor_mat_C(id, :);
    historical_income_rate_Actual = historical_income_rate_C;
elseif element == 'Mn'
    coefficient_matrix = [0.710515 0 0 -54.0805 0 0 0 1.01e-05 0 0 0 0 -0.000479763 0 0 0 -0.000335971 0 0.000260976 0 -3.30e-04 -0.000319902 0 0];
    factor_mat_simulation = factor_mat_Mn(id, :);
    historical_income_rate_Actual = historical_income_rate_Mn;
end
% coefficient_matrix_C = [0.666421  1.35255e-05  -397.073  0  0  0  -10.0705  1.27e-05  0  0  0.00268162  0  0.00162781  0  -0.000820824  0  -0.000112861  0  0  -0.0038281  -1.10e-04  -0.000120863  -0.000307686  0];
for i = 1:num
    historical_income_rate_simulation(i) = coefficient_matrix(1)+sum(coefficient_matrix(2:24).*factor_mat_simulation(i, 1:23));
end
plot(id, historical_income_rate_simulation','b.' );
hold on
plot(id, historical_income_rate_C(id), 'r.' );
plot(id, abs(historical_income_rate_simulation'-historical_income_rate_Actual(id))./historical_income_rate_Actual(id),'g.');
axis([-10 220 -0.1 1.1]);
title(['Simulation diagram-',element]);
xlabel('Sample number');
ylabel('percentage');
legend({'Simulation value','Actual value','Relative error'},'Location', 'NorthEastOutside');
hold off