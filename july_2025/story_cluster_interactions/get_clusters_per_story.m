function all_clusters = get_clusters_per_story(fin_table)

cols_of_interest = [fin_table.story_num fin_table.experiment];
all_clusters = [];
unique_combos = unique(cols_of_interest, "rows");
for i = 1:length(unique_combos)
    unique_combo = unique_combos(i,:);
    story = unique_combo(1);
    exp = unique_combo(2);
    cluster_groups = get_clusters_per_story_helper(fin_table, story, exp);
    all_clusters = [all_clusters; cluster_groups];
end

all_clusters = sortrows(all_clusters, "Percent","descend");

writetable(all_clusters, "clusters_per_story.csv")
end

function cluster_groups = get_clusters_per_story_helper(cluster_table, story, exp)

curr_story = cluster_table(cluster_table.story_num == story & ...
    cluster_table.experiment == exp, :);

cluster_groups = groupcounts(curr_story, "idx");
cluster_groups.actual_story = repelem(story + "/" + exp, height(cluster_groups), 1);
cluster_groups = sortrows(cluster_groups, "Percent","descend");

end