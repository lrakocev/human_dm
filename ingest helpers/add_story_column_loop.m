function [data_w_extra_col] = add_story_column_loop(approach_data)

data_w_extra_col = cell(1,length(approach_data));
for N = 1:length(approach_data)
    appr_table = approach_data{N};
    if ~isempty(appr_table)
        new_table = add_story_column(appr_table);        
        data_w_extra_col{N} = new_table;
    end
end
  