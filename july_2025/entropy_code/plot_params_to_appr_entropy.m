function plot_params_to_appr_entropy(appr_entropy_table,measure)

measure_lvls = appr_entropy_table.(measure+"_lvl");

variable_names = appr_lvl_table.Properties.VariableNames;
for i = 3:length(variable_names)

    figure
    measure_name = variable_names{i};
    current_col = appr_lvl_table.(measure_name);
    scatter(appr_lvl_top, current_col)
   
    title("appr lvl vs " + measure_name)

end