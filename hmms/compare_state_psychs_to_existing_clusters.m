function compare_state_psychs_to_existing_clusters(cluster_filename,state_funcs)

cluster_table = readtable(cluster_filename);

figure
scatter3(cluster_table.clusterX, cluster_table.clusterY, cluster_table.clusterZ,1,'r','o')

hold on
scatters = [];
colors = distinguishable_colors(length(state_funcs));
for j = 1:length(state_funcs)
    curr_func = state_funcs{j};
    coords = [curr_func.a, curr_func.b, curr_func.c];
    log_coords = log(abs(coords));
    scat = scatter3(log_coords(1),log_coords(2),log_coords(3), 1000,colors(j,:),'X');
    scatters = [scatters; scat];
    hold on
end

legend(scatters)
end