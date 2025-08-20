function plot_per_appr_lvl_params(appr_lvl_table)

appr_lvl_table = appr_lvl_table(appr_lvl_table.appr_lvl_top ~= 3 & appr_lvl_table.appr_lvl_top ~= 51, :);
appr_lvl_top = appr_lvl_table.appr_lvl_top;

variable_names = appr_lvl_table.Properties.VariableNames;
for i = 3:length(variable_names)

    figure
    measure_name = variable_names{i};
    current_col = appr_lvl_table.(measure_name);
    scatter(current_col,appr_lvl_top)
   
    title("appr lvl vs " + measure_name)

end