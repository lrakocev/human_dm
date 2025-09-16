function plot_per_cluster_params(measure_cluster_table,save_to)


variable_names = measure_cluster_table.Properties.VariableNames;
for i = 2:length(variable_names)
    figure
    measure_name = variable_names{i};

    sorted = sortrows(measure_cluster_table, measure_name);
    current_col = sorted.(measure_name);
    cluster_combos = measure_cluster_table.cluster_combo;

    figure
    scatter(cluster_combos,current_col)
    xlabel("cluster combo number")
    ylabel(measure_name)
   
    title("cluster combo vs " + measure_name)
    set(gcf,'renderer','Painters')
    saveas(gcf,save_to + "/" + measure_name + "_v_cluster","fig")
    saveas(gcf,save_to + "/" + measure_name + "_v_cluster","svg")
    close all 

end