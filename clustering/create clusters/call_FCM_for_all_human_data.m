function [] = call_FCM_for_all_human_data(table_of_dir,centers,directory_where_cluster_table_should_be_saved)
% created by Luis David Davila

cluster_table_dir_abs = create_a_file_if_it_doesnt_exist_and_ret_abs_path(directory_where_cluster_table_should_be_saved);
human_data_table =[];
for i=1:height(table_of_dir)
    experiment = table_of_dir{i,1};
    table_of_data_for_current_task = getTable(table_of_dir{i,2});
    F = table(repelem(experiment,height(table_of_data_for_current_task),1),'VariableNames',["F"]);
    table_of_data_for_current_task = [table_of_data_for_current_task,F];
    human_data_table = [human_data_table;table_of_data_for_current_task];

end

    raw_xVsYVsZ = [human_data_table.A,human_data_table.B,human_data_table.C];
    xVsYVsZ = log(abs(raw_xVsYVsZ));

    labels = [human_data_table.D,human_data_table.D];
    xAxis = "Log(Abs(Max))";
    yAxis = "log(abs(Shift))";
    zAxis = "log(abs(slope))";

    experiment_col = [human_data_table.F,human_data_table.F];
   
    called_by = "call_FCM_for_all_human_data.m";
    if isempty(centers)
        run_3d_fcm_analysis_for_all_human_data(xVsYVsZ,raw_xVsYVsZ,labels,xAxis,yAxis,zAxis,"all human data",called_by,[],experiment_col,cluster_table_dir_abs)
    else
        run_3d_fcm_analysis_for_all_human_data(xVsYVsZ,raw_xVsYVsZ,labels,xAxis,yAxis,zAxis,"all human data",called_by,centers,experiment_col,cluster_table_dir_abs)
    end
end