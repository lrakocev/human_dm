type = "all_clusters_original";
table_name = "C:\Users\lrako\OneDrive\Documents\human_dm\dec_2025\" + type + ".xlsx";
spectral_table = readtable(table_name);

%% prepping session data
using_2d_sigmoid = 0;
raw_sesh_data_across_rew = prepping_session_data(session_data, using_2d_sigmoid); 

%% getting the distances btwn raw or fitted sessions 

dir = 'C:\Users\lrako\OneDrive\Documents\human_dm\test_run\dec_2025';

save_to = 'C:\Users\lrako\OneDrive\Documents\human_dm\final_run_2026\friedman_metrics';
table_of_human_dir = get_dirs_with_data(dir);
using_fitted_vals = 1;
using_2d_sigmoid = 0;
num_functions_to_try = [];
num_comparisons = 7000;
sigmoid_table_2d = [];

[distances,cluster_diffs] = get_distances_btwn_funcs(spectral_table,...
    num_functions_to_try,num_comparisons,using_fitted_vals,using_2d_sigmoid,...
    sigmoid_table_2d, raw_sesh_data_across_rew);

%% cluster pcs 

num_clusters = 10;
[clustering_output, avg_diff] = clustering_pcs_of_dists(distances, cluster_diffs, num_clusters);
counts_per_cluster = groupcounts(clustering_output, "cluster_idx");

%%
same_per_cluster =  groupcounts(clustering_output, ["cluster_idx", "pts_in_same_cluster", "c1", "c2"]);
same_per_cluster.row_label = "(" + string(same_per_cluster.c1) + ", " + string(same_per_cluster.c2) + ")";
same_cluster_w_diffs = outerjoin(same_per_cluster, avg_diff, "Keys", {'cluster_idx'});

%% check the biggest subcluster

biggest_subcluster_idx = head(sortrows(counts_per_cluster, "Percent","desc"),1).cluster_idx;
biggest_subcluster = clustering_output(clustering_output.cluster_idx == biggest_subcluster_idx, :);

figure
scatter3(biggest_subcluster.pc_1, biggest_subcluster.pc_2, biggest_subcluster.pc_3);
title("biggest subcluster of the original set")

%% now re-do the pcs for this subcluster

dist_names = "dist_" + [1:4];
biggest_subcluster_dists = table2array(biggest_subcluster(: ,dist_names));

num_clusters = 10;
sub_clustering_output = clustering_pcs_of_dists(biggest_subcluster_dists, num_clusters);
counts_in_subcluster = sub_clustering_output(sub_clustering_output, "cluster_idx");