function diff_stories = compare_stories_across_clusters(cluster_table, c1, c2)

c1_story_summary = get_stories_per_cluster(cluster_table, c1);
c2_story_summary = get_stories_per_cluster(cluster_table, c2);

c1_stories = c1_story_summary.actual_story; 
c2_stories = c2_story_summary.actual_story;

diff_stories = [setdiff(c1_stories, c2_stories); setdiff(c2_stories,c1_stories)];

end