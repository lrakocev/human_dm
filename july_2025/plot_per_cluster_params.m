function plot_per_cluster_params(measure_cluster_table)

cluster_combos = measure_cluster_table.cluster_combo;

variable_names = measure_cluster_table.Properties.VariableNames;
for i = 2:length(variable_names)
    figure
    measure_name = variable_names{i};
    current_col = measure_cluster_table.(measure_name);
    scatter(cluster_combos,current_col)
   
    title("cluster combo vs " + measure_name)

end