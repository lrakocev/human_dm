function cleaned = clean_simulated_data(simulated_data)
    
simulated_table = struct2table(simulated_data);

unique_ids = unique(simulated_table.subjectidnumber);
num_ids = length(unique_ids);
cleaned = cell(1,num_ids);
for i = 1:num_ids
    id = unique_ids(i);
    id_table = simulated_table(simulated_table.subjectidnumber == id, :);
    cleaned{i} = id_table;
end