function [filtered_behavior_table, prim_table] = prep_data_for_hmm(home_dir,base_file_name,session_level)

if ~session_lvl
    load(home_dir + "clustering/july_2025/2d_clustering_subject_lvl_all_data_oct25.mat");
else
    load(home_dir + "clustering/july_2025/2d_clustering_0810.mat");
end

sig_table = renamevars(sig_table, "experiment", "story_type");

load(home_dir + base_file_name);

behavior_2d_sig_join = outerjoin(all_data, sig_table, "MergeKeys", 1, "Keys", {'subjectidnumber','story_num','story_type'});

if ~session_lvl
    table_name = home_dir + "october_2025/all_clusters_subject.xlsx";
else
    table_name = home_dir + "october_2025/all_clusters.xlsx";
end

sig_table_1d_messy = readtable(table_name);

sig_table_1d = psychs_in_spec_cluster(sig_table_1d_messy,1);
sig_table_1d = renamevars(sig_table_1d, "experiment", "story_type");

behavior_sig_full = outerjoin(behavior_2d_sig_join, sig_table_1d, "MergeKeys", 1, "Keys", {'subjectidnumber','story_num','story_type','cost'});

if ~session_lvl
    load(home_dir + "autoencoder_table.mat");
else
    load(home_dir + "autoencoder_session_table.mat")
end

including_autoencoder = outerjoin(behavior_sig_full, full_autoencoder_table, "MergeKeys", 1, "Keys", {'subjectidnumber', 'story_type', 'story_num'});
behavior_sig_clean = including_autoencoder(~isnan(including_autoencoder.a_R) & ~isnan(including_autoencoder.clusterX) & ~isnan(including_autoencoder.approach_rate), :);

num_trials_for_thresh = 16*4;
filtered_behavior_table = [];
unique_ids = unique(behavior_sig_clean.subjectidnumber);
for i = 1:length(unique_ids)
    id = unique_ids(i);
    subject_table = behavior_sig_clean(behavior_sig_clean.subjectidnumber == id, :);
    if height(subject_table) > num_trials_for_thresh
        filtered_behavior_table = [filtered_behavior_table; subject_table];
    end
end


filtered_behavior_table = renamevars(filtered_behavior_table, "clusterLabels_sig_table_1d", "clusterLabels");
range = get_interactions(filtered_behavior_table, "clusterLabels_behavior_2d_sig_join");
%subj_var = get_subj_var(cluster_mse);
sesh_var = get_sesh_var(range,"clusterLabels_behavior_2d_sig_join");
impulse = get_impulsivity(sesh_var,"clusterLabels_behavior_2d_sig_join");
prim_table = get_appr_bias(impulse,"clusterLabels_behavior_2d_sig_join");
%cluster_mse = get_cluster_mse(appr_bias);
%prim_table = get_mse(cluster_mse,"clusterLabels_behavior_2d_sig_join");


end