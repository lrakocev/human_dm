function bhatt_table = rat_hum_distance_2d(human_data_table,rat_data_table,normalize_or_dont,dir_to_save_figs_to,version_name,want_plot)
    function [distance_matrix,heat_map_x_labels,heat_map_y_labels] = get_bhat_distance_matrix(human_data_table,rat_data_table,rat_clusters,human_clusters)
        distance_matrix = zeros(length(rat_clusters),length(human_clusters));
      
        heat_map_x_labels = cell(1,length(human_clusters));
        heat_map_y_labels = cell(1,length(rat_clusters));
        for i=1:length(rat_clusters)
            curr_rat_cluster = rat_clusters(i);
            heat_map_y_labels{i} = char(strcat("Model Cluster ",string(curr_rat_cluster)));
            current_rat_cluster_table = rat_data_table(rat_data_table.cluster_number==curr_rat_cluster,:);
            
            rat_data = [current_rat_cluster_table.clusterY,current_rat_cluster_table.clusterZ];
            rat_labels = logical(zeros(size(current_rat_cluster_table,1),1));
            for j=1:length(human_clusters)
                curr_hu_cluster = human_clusters(j);
                if i==1
                    heat_map_x_labels{j} =char(strcat("Human Cluster ",string(curr_hu_cluster)));
                end
                current_human_cluster_table = human_data_table(human_data_table.cluster_number == curr_hu_cluster,:);
                hu_data = [current_human_cluster_table.clusterY,current_human_cluster_table.clusterZ];
                hu_labels = logical(zeros(size(hu_data,1),1)+1);

                try 
                    dimensions_of_bhat_distance = pdist2(hu_data,rat_data);
                    distance_matrix(i,j) = mean(dimensions_of_bhat_distance,'all');
                catch
                    distance_matrix(i,j) = 10;
                end
            end
        end
    end
    function [] = create_heat_map(matrix_to_turn_into_heat_map,dir_to_save_figs_to,heat_map_x_labels,heat_map_y_labels)
       figure;
        the_color_map_to_use = generatecolormapthreshold([0,1,1.1,round(max(matrix_to_turn_into_heat_map,[],"all"))],[1 1 1; 0 0.4470 0.7410;0 0.4470 0.7410]);
        heatmap(heat_map_x_labels,heat_map_y_labels,matrix_to_turn_into_heat_map, 'ColorMap',the_color_map_to_use,'ColorLimits',[0,round(max(matrix_to_turn_into_heat_map,[],"all"))]);

        title("Mean Euclidean Distance between model clusters vs human clusters" + newline)

        set(gcf,'renderer','Painters');
        save_title = strcat(dir_to_save_figs_to,"\","Euclidean Distance Between Model Clusters to Human Approach Avoid Clusters");
        saveas(gcf,strcat(save_title,".svg"),"svg")
        saveas(gcf,strcat(save_title,".fig"),"fig")
    end

dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);

human_clusters = unique(human_data_table.cluster_number);
rat_clusters = unique(rat_data_table.cluster_number);

if normalize_or_dont
    normalized_human_data = normalize([human_data_table.clusterY,human_data_table.clusterZ],"range",[0,1]);
    human_data_table.clusterY = normalized_human_data(:,1);
    human_data_table.clusterZ = normalized_human_data(:,2);

    normalized_rat_data = normalize([rat_data_table.clusterY,rat_data_table.clusterZ],"range",[0,1]);
    rat_data_table.clusterY = normalized_rat_data(:,1);
    rat_data_table.clusterZ = normalized_rat_data(:,2);
end

[distance_matrix,heat_map_x_labels,heat_map_y_labels] = get_bhat_distance_matrix(human_data_table,rat_data_table,rat_clusters,human_clusters);

distance_matrix(isinf(distance_matrix)) = 1000;

hum_idxs = repelem(1:length(human_clusters), 1, length(rat_clusters));
model_idxs = repmat(1:length(rat_clusters),1, length(human_clusters));
bhatt_table.model_idx = model_idxs';
bhatt_table.hum_idx = hum_idxs';
bhatt_table.avg_dist = distance_matrix(:);
bhatt_table = struct2table(bhatt_table);
if want_plot
    create_heat_map(distance_matrix,dir_to_save_figs_to,heat_map_x_labels,heat_map_y_labels)
end



end