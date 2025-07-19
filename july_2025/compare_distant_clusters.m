%% compare distant clusters

cluster_table = readtable("all_clusters.xlsx");

[group, ID] = findgroups(cluster_table.cluster_number);
meanX = splitapply(@mean, cluster_table.clusterX, group);
meanY = splitapply(@mean, cluster_table.clusterY, group);
meanZ = splitapply(@mean, cluster_table.clusterZ, group);

coords = [meanX meanY meanZ];
all_pairs = nchoosek(1:15,2);
%%
dist_table = [];
for i = 1:length(all_pairs)
    cluster1 = all_pairs(i,1);
    cluster2 = all_pairs(i,2);
    dist = norm(coords(cluster1,:) - coords(cluster2,:));
    row.cluster1 = cluster1;
    row.cluster2 = cluster2;
    row.dist = dist;
    dist_table = [dist_table; row];
end
    
dist_table = struct2table(dist_table);

dist_table = sortrows(dist_table, 'dist','descend');
top_diff = head(dist_table, 1);


%% how to compare the most distant clusters? need to link them to their behavioral data -- have i done this before.. 

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
