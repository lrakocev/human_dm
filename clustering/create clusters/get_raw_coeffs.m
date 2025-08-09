function get_raw_coeffs(table_of_dir,directory_where_cluster_table_should_be_saved,epsilon,given_number_of_clusters,colors,method,is_big)
table_of_data = cell2table(cell(0,5),"VariableNames",["A","B","C","D","E"]);
directory_where_cluster_table_should_be_saved = create_a_file_if_it_doesnt_exist_and_ret_abs_path(directory_where_cluster_table_should_be_saved);
for i=1:height(table_of_dir)
    current_table = getTableBig(table_of_dir{i,2},is_big);
    E = repelem(table_of_dir{i,1},height(current_table),1);
    E = table(E);
    current_table = [current_table,E];
    table_of_data = [table_of_data;current_table];
end

task = "All_Human_data";
% not taking log(abs()) here - want to get raw coeffs
xVsYVsZ = [table_of_data.A,table_of_data.B,table_of_data.C];
labels = [table_of_data.D,table_of_data.D];

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
end