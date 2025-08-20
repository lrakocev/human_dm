function measure_cluster_table = parameters_per_cluster(merged_table)

existing_groups = groupcounts(merged_table, ["idx_clusters_2d","idx_clusters_1d"]);
valid_groups = existing_groups(~isnan(existing_groups.idx_clusters_2d) ...
    & ~isnan(existing_groups.idx_clusters_1d), :);

valid_groups.index = [1:48]';

all_rows = [];
for i = 1:height(valid_groups)
    pair = valid_groups(i, :);
   
    pair_table = merged_table(merged_table.idx_clusters_2d == pair.idx_clusters_2d & ...
        merged_table.idx_clusters_1d == pair.idx_clusters_1d, :);

    measures = ["approach_rate", "pupil_diameter", "pain", "hunger", "tiredness", "story_prefs"];
    
    curr_row.cluster_combo = i;
    for j = 1:length(measures)
        measure = measures(j);
        
        measure_data = pair_table.(measure);

        curr_row.(measure+"_mean") = mean(measure_data,'omitnan');
        curr_row.(measure+"_entropy") = calc_entropy(measure_data);
        curr_row.(measure+"_variance") = var(measure_data,'omitnan');
        %curr_row.(measure+"_sensitivity") = calc_sensitivity(measure_data);
        
    end

    all_rows = [all_rows; curr_row];
end

measure_cluster_table = struct2table(all_rows);

end
