function spectral_clustering_raw_feats(data_table, num_clusters, method, colors, save_to, file_name)


xVsY = [data_table.clusterY, data_table.clusterZ];
labels = [data_table.sesh_label,data_table.sesh_label];

xVsY = real(xVsY);
xVsY = xVsY(sum(isnan(xVsY),2)==0,:);
%[index] = dbscan(xVsYVsZ,1,20);
[index,V,D] = spectralcluster(xVsY,num_clusters,'Distance',method);

unique_indexes = unique(index);

figure;
for j=1:length(unique_indexes)
    current_color = colors(j,:);
    group_n = xVsY(index==unique_indexes(j),:);

    scatter_object = scatter(group_n(:,1),group_n(:,2),[],current_color);
    dtRows = [dataTipTextRow("Data Label",strrep(labels(index==unique_indexes(j),1),"_","\_")),...
        dataTipTextRow("Cluster",repelem(unique_indexes(j),size(group_n,1),1)), ...
        dataTipTextRow("Story",data_table.story_type(index==unique_indexes(j)))];

    scatter_object.DataTipTemplate.DataTipRows(end+1:end+3) = dtRows;
    three_d_cluster_table = getClusterTable3dWithExperiment(xVsY,[],labels,index,unique_indexes(j),data_table.story_type);
    writetable(three_d_cluster_table,strcat(save_to,"\" + file_name + ".xlsx"),'WriteMode','append')
    hold on;
end

% validity = dbcv(xVsYVsZ,index);
legend(string(unique_indexes));
ylabel(feat2);
xlabel(feat1);
zlabel(feat3);
title("spectral clustering")
subtitle("Created by call_spectral_clustering_combine_all_human_data")
hold off;

end