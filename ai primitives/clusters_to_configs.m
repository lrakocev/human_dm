function [table_of_data, param_data, index] = clusters_to_configs(table_of_data, param_table, rand_rows,given_number_of_clusters,colors,method,save_to)

param_data = param_table(rand_rows, :);

xVsYVsZ = log(abs([table_of_data.A,table_of_data.B,table_of_data.C]));
[index,V,D] = spectralcluster(xVsYVsZ,given_number_of_clusters,'Distance',method);
unique_indexes = unique(index);
disp("V")
disp(V);
disp("D")
disp(D);
labels = [table_of_data.D,table_of_data.D];

figure;
for j=1:length(unique_indexes)
    current_color = colors(j,:);
    group_n = xVsYVsZ(index==unique_indexes(j),:);

    scatter3(group_n(:,1),group_n(:,2),group_n(:,3),[],current_color);
    hold on

    three_d_cluster_table = getClusterTable3dWithExperiment(xVsYVsZ,[],labels,index,unique_indexes(j),[]);
    writetable(three_d_cluster_table,strcat(save_to,"\all_experiment_clustered_together.xlsx"),'WriteMode','append')
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
set(gcf,'renderer','Painters')
hold off;

end