function plot_model_configurations(bhatt_table, param_data, colors, save_to)

close_bhatt_table = bhatt_table(bhatt_table.bhatt_dist <= 1, :);
unique_clusters = unique(close_bhatt_table.model_idx);
 
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
saveas(gcf,save_to + "\configs_cluster_3d" + ".fig","svg")
%saveas(gcf,save_to + "\configs_cluster_3d" + ".svg", "svg")

set(gcf,'renderer','Painters')

end