%% human data load

type = "all_cost_5_clusters";
table_name = "C:\Users\lrako\OneDrive\Documents\human dm\" + type + ".xlsx";
human_data = readtable(table_name);

%% get model clusters OR

load("subset_dirk_space.mat")

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\10_13_24";
mkdir(save_to)
num_clusters = 12;
colors = distinguishable_colors(30);
[dirk_cluster_data, param_data, index] = clusters_to_configs(myTable, param_table, rand_rows, num_clusters ,colors,'euclidean',save_to);
savefig(save_to + "\dirk_clustering_" + string(num_clusters) + ".fig")
%close all 

%% load pre-calc'd clusters

load("subset_dirk_space.mat")
param_data = param_table(rand_rows, :);

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\10_13_24";
dirk_cluster_table = readtable(save_to + "\all_experiment_clustered_together.xlsx");

%%

%{
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\06_10_04";

dirk_table_name = save_to + "/all_experiment_clustered_together.xlsx";
dirk_cluster_data = readtable(dirk_table_name);
%}
param_data.clusterLabels = param_data.count + ".mat";

dirk_cluster_params = outerjoin(dirk_cluster_table,param_data,'Keys',{'clusterLabels'},'MergeKeys',1);
dirk_cluster_params = dirk_cluster_params(~isnan(dirk_cluster_params.cluster_number),:);

bhatt_table = get_bhat_dist_heat_map_comparing_rat_to_human(human_data,dirk_cluster_params,0, ...
    save_to,"dirk_v_hum_1013",1,1);

normalized_human_to_rat_comparison_single_plot(dirk_cluster_table, ...
    human_data,save_to, "3d cluster plot dirk to human comparison",colors,0)


%% cluster config plot for human-adjacent clusters

close_bhatt_table = bhatt_table(bhatt_table.bhatt_dist <= 1, :);

param_data.cluster = index; 
unique_clusters = unique(close_bhatt_table.model_idx);
 
%colors = distinguishable_colors(num_clusters);

figure
hs = [];
for k = 1:length(unique_clusters)
    c = unique_clusters(k);
    cluster_table = param_data(param_data.cluster == c, :);

    configs = groupcounts(cluster_table, ["strio", "DA_b", "LH0"]);
    collected = 0;
    for i = 1:height(configs)

        row = configs(i,:);
        strio = row.strio;
        da = row.DA_b;
        lh = row.LH0;
        num = row.Percent * 100;

        h = scatter3(strio, da, lh, num, colors(c,:),'filled');
        if collected == 0
            hs = [hs; h];
            collected = 1;
        end
        hold on
    end
end

xlabel('strio hz')
ylabel('da hz')
zlabel('lh hz')

sgtitle("3d config plot")
legend(hs,string(unique_clusters))
set(gcf,'renderer','Painters')
saveas(gcf,save_to + "\configs_cluster_3d" + string(num_clusters) + ".fig","svg")
%saveas(gcf,save_to + "\configs_cluster_3d" + string(num_clusters) + ".svg", "svg")

set(gcf,'renderer','Painters')

%% individual cluster config plots

param_data.cluster = index;
num_clusters = 12;
%colors = distinguishable_colors(num_clusters);

mean_params = [];
hs = [];
for c = 1:num_clusters
    cluster_table = param_data(param_data.cluster == c, :);

    if height(cluster_table) > 0

    configs = groupcounts(cluster_table, ["strio", "DA_b", "LH0"]);
    collected = 0;
    figure
    for i = 1:height(configs)

        row = configs(i,:);
        strio = row.strio;
        da = row.DA_b;
        lh = row.LH0;
        num = row.Percent * 100;

       
        h = scatter3(strio, da, lh, num, colors(c,:),'filled');
        if collected == 0
            hs = [hs; h];
            collected = 1;
        end
        hold on
        
    end
    hold off
    xlabel('strio hz')
    ylabel('da hz')
    zlabel('lh hz')
   
    
    sgtitle("3d config plot for cluster " + string(c))
    set(gcf,'renderer','Painters')
    saveas(gcf, save_to + "\configs_cluster_3d_separate_cluster_" + string(c) + ".fig","fig")
    saveas(gcf, save_to +"\configs_cluster_3d_separate_cluster_" + string(c) + ".svg", "svg")
    close all
    end
end
