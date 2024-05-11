function call_spectral_clustering_combine_all_human_data(table_of_dir,directory_where_cluster_table_should_be_saved,epsilon,given_number_of_clusters,colors,method)
table_of_data = cell2table(cell(0,5),"VariableNames",["A","B","C","D","E"]);
directory_where_cluster_table_should_be_saved = create_a_file_if_it_doesnt_exist_and_ret_abs_path(directory_where_cluster_table_should_be_saved);
for i=1:height(table_of_dir)
    current_table = getTable(table_of_dir{i,2});
    E = repelem(table_of_dir{i,1},height(current_table),1);
    E = table(E);
    current_table = [current_table,E];
    table_of_data = [table_of_data;current_table];
end

task = "All_Human_data";
xVsYVsZ = log(abs([table_of_data.A,table_of_data.B,table_of_data.C]));
labels = [table_of_data.D,table_of_data.D];

% [~,V_temp,D_temp] = spectralcluster(xVsYVsZ,5);
% 
% number_of_clusters = sum(D_temp==0);

[index,V,D] = spectralcluster(xVsYVsZ,given_number_of_clusters,'Distance',method);
unique_indexes = unique(index);
disp("V")
disp(V);
disp("D")
disp(D);

figure;
for j=1:length(unique_indexes)
    current_color = colors(j,:);
    group_n = xVsYVsZ(index==unique_indexes(j),:);

    scatter_object = scatter3(group_n(:,1),group_n(:,2),group_n(:,3),[],current_color);
    dtRows = [dataTipTextRow("Data Label",strrep(labels(index==unique_indexes(j),1),"_","\_")),...
        dataTipTextRow("Cluster",repelem(unique_indexes(j),size(group_n,1),1)), ...
        dataTipTextRow("Story",table_of_data.E(index==unique_indexes(j)))];

    scatter_object.DataTipTemplate.DataTipRows(end+1:end+3) = dtRows;
    three_d_cluster_table = getClusterTable3dWithExperiment(xVsYVsZ,labels,index,unique_indexes(j),table_of_data.E);
    writetable(three_d_cluster_table,strcat(directory_where_cluster_table_should_be_saved,"\all_experiment_clustered_together.xlsx"),'WriteMode','append')
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