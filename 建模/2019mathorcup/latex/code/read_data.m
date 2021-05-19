function [ output_args ] = read_data( element, table1, table2 )
%read_data Read the data in Table
%   Need to enter the name of the element as a parameter, such as ¡®C¡¯
%   output_args:[weight_of_molten_steel, element_content_before, element_content_after, elemental_quality]
    if element == 'C'
        range_line = 810;
        element_id = 1;
    elseif element == 'Mn'
        range_line = 251;
        element_id = 2;
    end
    weight_of_molten_steel = table1(1:range_line, 10);
    element_content_before = table1(1:range_line, element_id+4);
    element_content_after = table1(1:range_line, element_id+10);
    elemental_quality = 0;
    for i=1:16
        elemental_quality = elemental_quality+table1(1:range_line, 28+i).*table2(i, element_id);
    end
    output_args = [weight_of_molten_steel, element_content_before, element_content_after, elemental_quality];
    
end

