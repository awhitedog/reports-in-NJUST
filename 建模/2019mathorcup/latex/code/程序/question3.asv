
%---------------- Empty the workspace ----------------%
clearvars -except D1 D2 coefficient Optimized_coefficient;
clc;

%---------------- Initial parameter ----------------%
element = 'Si';
num = 100;
id = randperm(208, num);  % Get a random number

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
historical_income_rate = preprocess_mat(:, 1);
factor_mat = [preprocess_mat(:, 2:end), preprocess_mat(:, 2:end).^2]; 

%---------------- Data calculation ------------------%
factor_mat_simulation = factor_mat(id, :);  % Extract random data
historical_income_rate_Actual = historical_income_rate(id);
    %------- historical_income_rate_simulation of pre and advanced-------%

%     for i = 1:num
%         historical_income_rate_simulation_1(i,1) = coefficient(element_id, 1)+sum(coefficient(element_id, 2:end).*factor_mat_simulation(i, 1:23));
%     end
% %     historical_income_rate_simulation_1 = historical_income_rate_simulation_1';

    for i = 1:num
        historical_income_rate_simulation_2(i,1) = Optimized_coefficient(element_id, 1)+sum(Optimized_coefficient(element_id, 2:end).*factor_mat_simulation(i, :));
    end
%     historical_income_rate_simulation_2 = historical_income_rate_simulation_2';


% relative_error_1 = abs(historical_income_rate_simulation_1 - historical_income_rate_Actual)./historical_income_rate_Actual;
relative_error_2 = abs(historical_income_rate_simulation_2 - historical_income_rate_Actual)./historical_income_rate_Actual;

%--------------------plot pictures-------------------%
% figure(2);
%     plot(id, historical_income_rate_simulation_2','b.' );
%     hold on
%     plot(id, historical_income_rate_Actual, 'r.' );
%     plot(id, relative_error_2,'g.');
%     axis([-10 215 -0.1 1.1]);
%     title(['Simulation diagram-',element, '-optimized']);
%     xlabel('Sample number');
%     ylabel('percentage');
%     legend({'Simulation value','Actual value','Relative error'},'Location', 'NorthEastOutside');
%     hold off
% mean(relative_error_2)

%-------------Export Lagrangian multiplier------------%

