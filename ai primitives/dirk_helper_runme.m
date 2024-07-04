load("subset_dirk_space.mat")

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\06_10_04";
mkdir(save_to)
num_clusters = 12;
colors = distinguishable_colors(num_clusters);
[dirk_cluster_data, param_data, index] = clusters_to_configs(myTable, param_table, rand_rows, num_clusters ,colors,'euclidean',save_to);
savefig(save_to + "\dirk_clustering_" + string(num_clusters) + ".fig")
%close all 

%% full cluster config plot

param_data.cluster = index;
num_clusters = 12;
colors = distinguishable_colors(num_clusters);

figure
hs = [];
for c = 1:num_clusters
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
legend(hs)
set(gcf,'renderer','Painters')
savefig(save_to + "\configs_cluster_3d" + string(num_clusters) + ".fig")
savefig(save_to + "\configs_cluster_3d" + string(num_clusters) + ".svg", "svg")

set(gcf,'renderer','Painters')

%% individual cluster config plots

param_data.cluster = index;
num_clusters = 12;
colors = distinguishable_colors(num_clusters);

mean_params = [];
hs = [];
for c = 1:num_clusters
    cluster_table = param_data(param_data.cluster == c, :);

    if height(cluster_table) < 20

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
    legend(hs)
    set(gcf,'renderer','Painters')
    %saveas(gcf, save_to + "\configs_cluster_3d_separate_cluster_" + string(c) + ".fig","fig")
    %saveas(gcf, save_to +"\configs_cluster_3d_separate_cluster_" + string(c) + ".svg", "svg")
    end
end
