function all_stories = get_stories_per_cluster(fin_table)

all_stories = [];
for i = 1:max(fin_table.idx)
    story_groups = get_stories_per_cluster_helper(fin_table, i);
    all_stories = [all_stories; story_groups];
end

all_stories = sortrows(all_stories, "GroupCount","descend");

end

function story_groups = get_stories_per_cluster_helper(cluster_table, cluster)

curr_cluster = cluster_table(cluster_table.idx == cluster, :);
story_groups = groupcounts(curr_cluster, ["experiment", "story_num"]);

story_groups.actual_story = string(story_groups.experiment) + "/" + story_groups.story_num;
story_groups.cluster = repelem(cluster,height(story_groups),1);
story_groups = sortrows(story_groups, "Percent","descend");

end