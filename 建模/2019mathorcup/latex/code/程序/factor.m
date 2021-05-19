function [ output_args ] = factor( element, table1 )
%factor Export the valid factors in Table 1
%   Need to enter Table 1 as a parameter
%   output_args:[temperature, initial_value, weight_of_molten_steel, final_value, input_material]
    if element == 'C'
        range_line = 810;
    elseif element == 'Mn'
        range_line = 251;
    end

    temperature             =   table1(1:range_line, 4);
    initial_value           =   table1(1:range_line, 5:9);
    weight_of_molten_steel  =   table1(1:range_line, 10);
%     final_value             =   table1(1:range_line, 11:28);
    input_material          =   table1(1:range_line, 29:44);
    
%     output_args = [temperature, initial_value, weight_of_molten_steel, final_value, input_material];
    output_args = [temperature, initial_value, weight_of_molten_steel, input_material];
end

