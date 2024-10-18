function spectral_clustering_2D_sig(data_table, feats, num_clusters, method, colors, save_to, file_name)

xVsYVsZ = [data_table.a_R,data_table.b_R, data_table.b_C];
labels = [data_table.clusterLabels,data_table.clusterLabels];

if method == "density"
    index = dbscan(xVsYVsZ,7.5,10);
else
    [index,V,D] = spectralcluster(xVsYVsZ,num_clusters,'Distance','euclidean');
end

unique_indexes = unique(index);

figure;
scatters = [];
for j=1:length(unique_indexes)
    current_color = colors(j,:);
    group_n = xVsYVsZ(index==unique_indexes(j),:);

    scatter_object = scatter3(group_n(:,1),group_n(:,2),group_n(:,3),[],current_color);
    scatters = [scatters; scatter_object];
    dtRows = [dataTipTextRow("Data Label",strrep(labels(index==unique_indexes(j),1),"_","\_")),...
        dataTipTextRow("Cluster",repelem(unique_indexes(j),size(group_n,1),1)), ...
        dataTipTextRow("Story",data_table.experiment(index==unique_indexes(j)))];

    scatter_object.DataTipTemplate.DataTipRows(end+1:end+3) = dtRows;
    three_d_cluster_table = getClusterTable3dWithExperiment(xVsYVsZ,[],labels,index,unique_indexes(j),data_table.experiment);
    writetable(three_d_cluster_table,strcat(save_to,"\" + file_name + ".xlsx"),'WriteMode','append')
    hold on;
end

% validity = dbcv(xVsYVsZ,index);
legend(scatters,string(unique_indexes));
xlabel(feats(1));
ylabel(feats(2));
zlabel(feats(3))
title("spectral clustering for 2d sig fit")
subtitle("Created by 2d clustering")
hold off;
xlim([-100 170])
ylim([-100 120])
zlim([-140 70])
set(gcf,'renderer','Painters')
saveas(gcf,save_to + "\2d spec clustering", "fig")
saveas(gcf,save_to + "\2d spec clustering", "svg")

end