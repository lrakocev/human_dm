function plot_individual_configurations(param_data, colors, save_to)

num_clusters = length(unique(param_data.cluster));

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

end