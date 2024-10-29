function spectral_clustering_2D_sig(data_table, feats, colors, centers, save_to, file_name)

xVsYVsZ = [data_table.a_R,data_table.b_R, data_table.b_C];
labels = [data_table.clusterLabels,data_table.clusterLabels];

opt = fcmOptions(ClusterCenters=centers,NumClusters = size(centers,1));
[centers_determined_by_fcm,U,~,info] = fcm(xVsYVsZ,opt);
mpc = calculate_mpc(U);
maxU = max(U);
optimum_number_of_clusters = info.OptimalNumClusters;
%index = dbscan(xVsYVsZ,7.5,10);
%unique_indexes = unique(index);

figure;
scatters = [];
for j=1:optimum_number_of_clusters %length(unique_indexes)
    current_color = colors(j,:);
    indexes = find(U(j,:)==maxU);
    scatter_object = scatter3(xVsYVsZ(indexes,1),xVsYVsZ(indexes,2),xVsYVsZ(indexes,3),[],current_color);

    %group_n = xVsYVsZ(index==unique_indexes(j),:);
    %scatter_object = scatter3(group_n(:,1),group_n(:,2),group_n(:,3),[],current_color);
    scatters = [scatters; scatter_object];
    %{
    dtRows = [dataTipTextRow("Data Label",strrep(labels(index==unique_indexes(j),1),"_","\_")),...
        dataTipTextRow("Cluster",repelem(unique_indexes(j),size(group_n,1),1)), ...
        dataTipTextRow("Story",data_table.experiment(index==unique_indexes(j)))];
    scatter_object.DataTipTemplate.DataTipRows(end+1:end+3) = dtRows;
    three_d_cluster_table = getClusterTable3dWithExperiment(xVsYVsZ,[],labels,indexes,unique_indexes(j),data_table.experiment);
    %}
   three_d_cluster_table = getClusterTable3d(xVsYVsZ,labels,indexes,j,data_table.experiment);

    writetable(three_d_cluster_table,strcat(save_to,"\" + file_name + ".xlsx"),'WriteMode','append')
    hold on;
end

% validity = dbcv(xVsYVsZ,index);
legend(scatters,string(1:optimum_number_of_clusters)); % string(unique_indexes)
xlabel(feats(1));
ylabel(feats(2));
zlabel(feats(3))
title("clustering for 2d sig fit, mpc = " + string(mpc))
subtitle("Created by 2d clustering")
hold off;
xlim([-100 170])
ylim([-100 120])
zlim([-140 70])
set(gcf,'renderer','Painters')
saveas(gcf,save_to + "\2d spec clustering", "fig")
saveas(gcf,save_to + "\2d spec clustering", "svg")

end