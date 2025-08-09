function bhatt_table = get_bhat_dist_heat_map_comparing_rat_to_human(human_data_table,rat_data_table,normalize_or_dont,dir_to_save_figs_to,version_name,create_average_plot_or_dont,want_plot)
    function [bhat_distance_matrix_max,bhat_distance_matrix_shift,bhat_distance_matrix_slope,heat_map_x_labels,heat_map_y_labels] = get_bhat_distance_matrix(human_data_table,rat_data_table,rat_clusters,human_clusters)
        bhat_distance_matrix_max = zeros(length(rat_clusters),length(human_clusters));
        bhat_distance_matrix_shift = zeros(length(rat_clusters),length(human_clusters));
        bhat_distance_matrix_slope = zeros(length(rat_clusters),length(human_clusters));
        
        heat_map_x_labels = cell(1,length(human_clusters));
        heat_map_y_labels = cell(1,length(rat_clusters));
        for i=1:length(rat_clusters)
            curr_rat_cluster = rat_clusters(i);
            heat_map_y_labels{i} = char(strcat("Model Cluster ",string(curr_rat_cluster)));
            current_rat_cluster_table = rat_data_table(rat_data_table.cluster_number==curr_rat_cluster,:);
            rat_data = [current_rat_cluster_table.clusterX,current_rat_cluster_table.clusterY,current_rat_cluster_table.clusterZ];
            rat_labels = logical(zeros(size(current_rat_cluster_table,1),1));
            for j=1:length(human_clusters)
                curr_hu_cluster = human_clusters(j);
                if i==1
                    heat_map_x_labels{j} =char(strcat("Human Cluster ",string(curr_hu_cluster)));
                end
                current_human_cluster_table = human_data_table(human_data_table.cluster_number == curr_hu_cluster,:);
                hu_data = [current_human_cluster_table.clusterX,current_human_cluster_table.clusterY,current_human_cluster_table.clusterZ];
                hu_labels = logical(zeros(size(hu_data,1),1)+1);

                try 
                    dimensions_of_bhat_distance =  bhattacharyyaDistance([hu_data;rat_data],[hu_labels;rat_labels]);
                    
                    bhat_distance_matrix_max(i,j) = dimensions_of_bhat_distance(1);
                    bhat_distance_matrix_shift(i,j) = dimensions_of_bhat_distance(2);
                    bhat_distance_matrix_slope(i,j) = dimensions_of_bhat_distance(3);
                catch
                    bhat_distance_matrix_max(i,j) = 10;
                    bhat_distance_matrix_shift(i,j) = 10;
                    bhat_distance_matrix_slope(i,j) = 10;
                end
            end
        end
    end
    function [] = create_heat_map(matrix_to_turn_into_heat_map,which_dimension,dir_to_save_figs_to,heat_map_x_labels,heat_map_y_labels,normalize_or_dont,version_name)
       figure;
        the_color_map_to_use = generatecolormapthreshold([0,1,1.1,round(max(matrix_to_turn_into_heat_map,[],"all"))],[1 1 1; 0 0.4470 0.7410;0 0.4470 0.7410]);
        heatmap(heat_map_x_labels,heat_map_y_labels,matrix_to_turn_into_heat_map, 'ColorMap',the_color_map_to_use,'ColorLimits',[0,round(max(matrix_to_turn_into_heat_map,[],"all"))]);
        %heatmap(heat_map_x_labels,heat_map_y_labels,matrix_to_turn_into_heat_map,'ColorLimits',[0,round(max(matrix_to_turn_into_heat_map,[],"all"))]);

        % clim([0,1])
        if which_dimension==1
            to_add_to_tile = "log(abs(max))";
        elseif which_dimension==2
            to_add_to_tile = "log(abs(shift))";
        elseif which_dimension==3
            to_add_to_tile = "log(abs(slope))";
        elseif which_dimension == 0
            to_add_to_tile = "Average of log(abs(max)),log(abs(shift)),log(abs(slope))";
        end

        if normalize_or_dont
            to_add_to_tile = to_add_to_tile+" Normalized";
        else
            to_add_to_tile = to_add_to_tile+" Not Normalized";
        end

        title("Mean Bhattacharya Distance between model clusters vs human clusters" + newline + to_add_to_tile)

        set(gcf,'renderer','Painters');
        save_title = strcat(dir_to_save_figs_to,"\","Bhat Distance Between Model Clusters to Human Approach Avoid Clusters ",to_add_to_tile," ",version_name);
        saveas(gcf,strcat(save_title,".svg"),"svg")
        saveas(gcf,strcat(save_title,".fig"),"fig")
    end
if normalize_or_dont
    normalized_human_data = normalize([human_data_table.clusterX,human_data_table.clusterY,human_data_table.clusterZ],"range",[0,1]);
    human_data_table.clusterX = normalized_human_data(:,1);
    human_data_table.clusterY = normalized_human_data(:,2);
    human_data_table.clusterZ = normalized_human_data(:,3);

    normalized_rat_data = normalize([rat_data_table.clusterX,rat_data_table.clusterY,rat_data_table.clusterZ],"range",[0,1]);
    rat_data_table.clusterX = normalized_rat_data(:,1);
    rat_data_table.clusterY = normalized_rat_data(:,2);
    rat_data_table.clusterZ = normalized_rat_data(:,3);
end
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);

human_clusters = unique(human_data_table.cluster_number);
rat_clusters = unique(rat_data_table.cluster_number);

[bhat_distance_matrix_max,bhat_distance_matrix_shift,bhat_distance_matrix_slope,heat_map_x_labels,heat_map_y_labels] = get_bhat_distance_matrix(human_data_table,rat_data_table,rat_clusters,human_clusters);

bhat_distance_matrix_max(isinf(bhat_distance_matrix_max)) = 10;
bhat_distance_matrix_shift(isinf(bhat_distance_matrix_shift)) = 10;
bhat_distance_matrix_slope(isinf(bhat_distance_matrix_slope)) = 10;

if ~create_average_plot_or_dont
    create_heat_map(bhat_distance_matrix_max,1,dir_to_save_figs_to,heat_map_x_labels,heat_map_y_labels,normalize_or_dont,version_name);
    create_heat_map(bhat_distance_matrix_shift,2,dir_to_save_figs_to,heat_map_x_labels,heat_map_y_labels,normalize_or_dont,version_name);
    create_heat_map(bhat_distance_matrix_slope,3,dir_to_save_figs_to,heat_map_x_labels,heat_map_y_labels,normalize_or_dont,version_name);
else
    average_matrix = (bhat_distance_matrix_max+bhat_distance_matrix_shift+bhat_distance_matrix_slope) ./3;

    hum_idxs = repelem(1:length(human_clusters), 1, length(rat_clusters));
    model_idxs = repmat(1:length(rat_clusters),1, length(human_clusters));
    bhatt_table.model_idx = model_idxs';
    bhatt_table.hum_idx = hum_idxs';
    bhatt_table.bhatt_dist = average_matrix(:);
    bhatt_table = struct2table(bhatt_table);
    if want_plot
        create_heat_map(average_matrix,0,dir_to_save_figs_to,heat_map_x_labels,heat_map_y_labels,normalize_or_dont,version_name)
    end
end


end