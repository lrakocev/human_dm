function table_of_data = cluster_sig_space(table_of_data,directory_where_cluster_table_should_be_saved,given_number_of_clusters,colors,method,file_name)

directory_where_cluster_table_should_be_saved = create_a_file_if_it_doesnt_exist_and_ret_abs_path(directory_where_cluster_table_should_be_saved);

raw_xVsYVsZ = [table_of_data.a,table_of_data.b,table_of_data.c];
xVsYVsZ = log(abs(raw_xVsYVsZ));

[index,V,D] = spectralcluster(xVsYVsZ,given_number_of_clusters,'Distance',method);
unique_indexes = unique(index);
disp("V")
disp(V);
disp("D")
disp(D);

experiment = repelem("theoretical",length(xVsYVsZ),1);

figure;
for j=1:length(unique_indexes)
    current_color = colors(j,:);
    group_n = xVsYVsZ(index==unique_indexes(j),:);

    scatter_object = scatter3(group_n(:,1),group_n(:,2),group_n(:,3),[],current_color);
    dtRows = dataTipTextRow("Cluster",repelem(unique_indexes(j),size(group_n,1),1));

    scatter_object.DataTipTemplate.DataTipRows(end+1:end+3) = dtRows;
    three_d_cluster_table = getClusterTable3dWithExperiment(xVsYVsZ,raw_xVsYVsZ,[],index,unique_indexes(j),experiment);
    writetable(three_d_cluster_table,strcat(directory_where_cluster_table_should_be_saved,"\" + file_name + ".xlsx"),'WriteMode','append')
    hold on;
end

% validity = dbcv(xVsYVsZ,index);
legend(string(unique_indexes));
ylabel("log(abs(Shift))");
xlabel("log(Abs(Max))");
zlabel("log(abs(slope))");
title("spectral clustering")
subtitle("Created by call_spectral_clustering_combine_all_human_data")
% subtitle(strcat(task," DBCV:",string(validity)," Created by call_spectral_clustering_combine_all_human_data"))
hold off;

end