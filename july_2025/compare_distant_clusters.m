%% compare distant clusters

[fin_table,dist_table] = get_most_distant_cluster_pairs(cluster_table);
top_diff = head(dist_table, 1);

writetable(dist_table, "distant_cluster_pairs.csv")

%% clusters per story + stories per cluster

all_stories = get_stories_per_cluster(fin_table);
all_clusters = get_clusters_per_story(fin_table);

%% how to compare the most distant clusters? need to link them to their behavioral data

load('C:\Users\lrako\OneDrive\Documents\human dm\test_run\no_filter_full_07_11.mat');

%%

story_types = ["all"];
all_data{1} = [super_sessions appr_avoid_sessions social_sessions probability_sessions moral_sessions];

all_psych_data = plot_avg_spec_cluster_psychs(cluster_table, all_data, 0, story_types, '', 0, 1, 0);
sesh_data = setup_for_avgs(all_data,story_types);

%%

[mean_apprs, max_apprs, min_apprs, var_appr, all_lvl_avgs] = summary_stats_per_cluster(sesh_data{1,1}, all_psych_data, 1);

%% cluster summary table

cluster_summary.coords = coords;
cluster_summary.mean_appr = mean_apprs;
cluster_summary.max_appr = max_apprs;
cluster_summary.min_appr = min_apprs;
cluster_summary.all_avgs = all_lvl_avgs;
cluster_summary.var_appr = var_appr;

cluster_summary.cluster_num = [1:height(coords)]';

%%
c1 = top_diff.cluster1;
c2 = top_diff.cluster2;

row1 = cluster_summary(cluster_summary.cluster_num == c1, :);
row2 = cluster_summary(cluster_summary.cluster_num == c2, :);

%% 

% get prim_table for this and choose whatever features make sense
prim_histogram_by_task(prim_table,hum_or_rat, "mean appr" , stories, want_save, save_to)
