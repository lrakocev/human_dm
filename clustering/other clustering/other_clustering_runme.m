%% human
num_clusters = 16;

colors = distinguishable_colors(num_clusters);
dir = 'C:\Users\lrako\OneDrive\Documents\human dm\test_run\session_clustering';
save_to = 'C:\Users\lrako\OneDrive\Documents\human dm\primitive building';
file_name = "human_clusters";
table_of_human_dir = get_dirs_with_data(dir);
is_big = 0;
call_spectral_clustering_combine_all_human_data(table_of_human_dir,save_to,0,num_clusters,colors,'euclidean',is_big,file_name)


%% raw features to cluster
story_types = "all";
all_data{1} = [appr_avoid_sessions moral_sessions social_sessions probability_sessions];
totals = setup_for_avgs(all_data,story_types);

totals = totals{1};
totals.sesh_label = totals.subjectidnumber + " " + totals.story_type + " " + totals.story_num;

feat_table = raw_features(totals);

%% color by param cluster

type = "all_session_updated";
main_hum = readtable("C:\Users\lrako\OneDrive\Documents\human dm\" + type + ".xlsx");

feat_table.clusterLabels = feat_table.subjectidnumber + "_" + feat_table.story_num + ".mat " + feat_table.story_type;
main_hum.clusterLabels = main_hum.clusterLabels + " " + main_hum.experiment;

merged = outerjoin(feat_table,main_hum,'MergeKeys',1,'Keys', 'clusterLabels');

nonnanmerge = merged(~isnan(merged.cluster_number), :);

color_raw_feats_by_cluster(nonnanmerge)
color_raw_feats_by_task(nonnanmerge)


%% clustering

num_clusters = 1;
method = 'euclidean';
colors = distinguishable_colors(num_clusters);
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\clustering\other clustering";
file_name = "lvl_clusters";%"max_min_med_clusters";
spectral_clustering_raw_feats(nonnanmerge, num_clusters, method, colors, save_to, file_name)


%% raw feats by task

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\task_prim_of_prims";
mkdir(save_to)
want_save = 1;
hum_or_rat = "human";
subj_var_means =  prim_histogram_by_task(feat_table,hum_or_rat, "subj var",want_save,save_to);
r_interact_means =  prim_histogram_by_task(feat_table,hum_or_rat, "reward interact",want_save,save_to);
r_impulse_means = prim_histogram_by_task(feat_table, hum_or_rat, "reward impulse",want_save,save_to);
c_impulse_means = prim_histogram_by_task(feat_table,hum_or_rat, "cost impulse",want_save,save_to);
c_interact_means = prim_histogram_by_task(feat_table,hum_or_rat, "cost interact",want_save,save_to);
max_appr_means = prim_histogram_by_task(feat_table,hum_or_rat, "max appr",want_save,save_to);
med_appr_means = prim_histogram_by_task(feat_table,hum_or_rat, "med appr",want_save,save_to);
mean_appr_means = prim_histogram_by_task(feat_table,hum_or_rat, "mean appr",want_save,save_to);
