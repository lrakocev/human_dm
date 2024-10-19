%% human data load

type = "all_session_updated";
table_name = "C:\Users\lrako\OneDrive\Documents\human dm\" + type + ".xlsx";
human_data = readtable(table_name);

%% get model clusters OR

load("subset_dirk_space.mat")

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\" + string(datetime("today"));
mkdir(save_to)
num_clusters = 12;
colors = distinguishable_colors(30);
[model_cluster_data, param_data, index] = clusters_to_configs(myTable, param_table, rand_rows, num_clusters ,colors,'euclidean',save_to);
savefig(save_to + "\model_clustering_" + string(num_clusters) + ".fig")
%close all 

%% load pre-calc'd clusters

load("subset_dirk_space.mat")
param_data = param_table(rand_rows, :);

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\10_13_24";
model_cluster_table = readtable(save_to + "\all_experiment_clustered_together.xlsx");

%% compare modeled data to human data

param_data.cluster = index; 
param_data.clusterLabels = param_data.count + ".mat";

model_cluster_params = outerjoin(model_cluster_table,param_data,'Keys',{'clusterLabels'},'MergeKeys',1);
model_cluster_params = model_cluster_params(~isnan(model_cluster_params.cluster_number),:);

bhatt_table = get_bhat_dist_heat_map_comparing_rat_to_human(human_data,model_cluster_params,0, ...
    save_to,"model_v_hum_1013",1,1);

normalized_human_to_rat_comparison_single_plot(model_cluster_table, ...
    human_data,save_to, "3d cluster plot model to human comparison",colors,0)

%% cluster config plot for human-adjacent clusters

plot_model_configurations(bhatt_table, param_data, colors, save_to)

%% individual cluster config plots

plot_individual_configurations(param_data, colors, save_to)