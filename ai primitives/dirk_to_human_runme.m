%% compare dirk clusters to human clusters

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\06_10_04";

dirk_table_name = save_to + "/all_experiment_clustered_together.xlsx";
dirk_cluster_data = readtable(dirk_table_name);

type = "all_cost_5_clusters";
table_name = "C:\Users\lrako\OneDrive\Documents\human dm\" + type + ".xlsx";
human_data = readtable(table_name);

version_name = "dirk_v_human_v1";

bhatt_table_norm = get_bhat_dist_heat_map_comparing_rat_to_human(human_data,dirk_cluster_data,1, ...
    save_to,version_name,1,1);

bhatt_table = get_bhat_dist_heat_map_comparing_rat_to_human(human_data,dirk_cluster_data,0, ...
    save_to,version_name,1,1);

%colors = distinguishable_colors(30);

normalized_human_to_rat_comparison_single_plot(dirk_cluster_data, ...
    human_data,save_to,"3d cluster plot dirk to human comparison",colors,1)

normalized_human_to_rat_comparison_single_plot(dirk_cluster_data, ...
    human_data,save_to, "3d cluster plot dirk to human comparison",colors,0)