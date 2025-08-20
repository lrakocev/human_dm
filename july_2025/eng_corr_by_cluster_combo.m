function all_corrs = eng_corr_by_cluster_combo(merged_table,want_plot)
% actually checking various eng types vs the combo

existing_groups = groupcounts(merged_table, ["idx_clusters_2d","idx_clusters_1d"]);
valid_groups = existing_groups(~isnan(existing_groups.idx_clusters_2d) ...
    & ~isnan(existing_groups.idx_clusters_1d), :);

valid_groups.index = [1:48]';

all_rows = [];
for i = 1:height(valid_groups)
    pair = valid_groups(i, :);
   
    pair_table = merged_table(merged_table.idx_clusters_2d == pair.idx_clusters_2d & ...
        merged_table.idx_clusters_1d == pair.idx_clusters_1d, :);
    
    measures = ["pupil_diameter", "pain", "hunger", "tiredness", "story_prefs"];
    
    curr_row.idx1 = pair.idx_clusters_1d;
    curr_row.idx2 = pair.idx_clusters_2d;
    for j = 1:length(measures)
        measure = measures(j);
        r = plot_corr(pair_table.approach_rate, pair_table.(measure), want_plot, "cluster combo " + string(i) + " corr appr rate and " + measure);
        
        curr_row.(measure) = r;
        
    end

    all_rows = [all_rows; curr_row];
end

all_corrs = struct2table(all_rows);

end

function r = plot_corr(v1, v2, want_plot, tit)

r = corr(v1, v2,'rows','complete');

if want_plot
figure
scatter(v1, v2)
title("corr btwn approach rate and " + tit + ": " + string(r))
end

end
