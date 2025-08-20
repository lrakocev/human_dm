function [r_table] = param_v_appr_entropy_per_cluster(merged_table,num_bins)

existing_groups = groupcounts(merged_table, ["idx_clusters_2d","idx_clusters_1d"]);
valid_groups = existing_groups(~isnan(existing_groups.idx_clusters_2d) ...
    & ~isnan(existing_groups.idx_clusters_1d), :);

valid_groups.index = [1:48]';

all_rows = [];
r_table.cluster_combo = [1:48]';
measures = ["pupil_diameter", "heart_rate", "pain", "hunger", "tiredness", "story_prefs", "cost", "rew"];
for i = 1:length(measures)
    measure = measures(i);

    figure(i)
    
    rs = [];
    for j = 1:height(valid_groups)
        pair = valid_groups(j, :);
      
        pair_table = merged_table(merged_table.idx_clusters_2d == pair.idx_clusters_2d & ...
            merged_table.idx_clusters_1d == pair.idx_clusters_1d, :);
    
        appr_entropy_table = parameters_per_appr_entropy(pair_table,num_bins,measure);
    
        if ~isempty(appr_entropy_table)
            hold on
            [prsq] = predict_appr_entropy(appr_entropy_table,measure,"cluster " + string(j));
        else
            prsq = 0;
        end
        rs = [rs; prsq];
       
    end
    hold off
    r_table.(measure+"r_sq") = rs;


end
r_table = struct2table(r_table);
end
