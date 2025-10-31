%% reducing the state library

reduced_state_table = all_people_state_table;
for colIdx = 2:8 % the feature values
    if isnumeric(reduced_state_table{:, colIdx})
        currentColumnData = reduced_state_table{:, colIdx};
        idx = currentColumnData > 0;
        currentColumnData(idx) = 1;
        reduced_state_table{:, colIdx} = currentColumnData;
    end
end

for colIdx = 9:15 % the feature values
    currentColumnData = reduced_state_table{:, colIdx};
    idx = ismissing(currentColumnData);
    currentColumnData(idx) = "na";
    reduced_state_table{:, colIdx} = currentColumnData;
end


reduced_state_table.state = [];

unique_state_rows = unique(reduced_state_table, 'rows');

gc = groupcounts(reduced_state_table, reduced_state_table.Properties.VariableNames);