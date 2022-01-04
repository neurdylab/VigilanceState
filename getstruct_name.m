function name_cell = getstruct_name(D)

name_cell = cell(length(D), 1);

for i = 1:length(D)
    
    name_cell{i} = D(i).name;
    
end

end