function [filtered_behavior_table, prim_table] = prep_data_for_hmm(home_dir,base_file_name)

load(home_dir + "clustering/alternative clustering/2d_sig_real.mat");
sig_table = renamevars(sig_table, "experiment", "story_type");

load(home_dir + base_file_name);

behavior_2d_sig_join = outerjoin(all_data, sig_table, "MergeKeys", 1, "Keys", {'subjectidnumber','story_num','story_type'});

table_name = home_dir + "july_2025/mysterious_mat/human_clusters.xlsx";
sig_table_1d_messy = readtable(table_name);

sig_table_1d = psychs_in_spec_cluster(sig_table_1d_messy,1);
sig_table_1d = renamevars(sig_table_1d, "experiment", "story_type");

behavior_sig_full = outerjoin(behavior_2d_sig_join, sig_table_1d, "MergeKeys", 1, "Keys", {'subjectidnumber','story_num','story_type','cost'});

load(home_dir + "autoencoder_clustering.mat");

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
range = get_interactions(filtered_behavior_table);
cluster_mse = get_cluster_mse(range);
%subj_var = get_subj_var(cluster_mse);
%sesh_var = get_sesh_var(subj_var);
impulse = get_impulsivity(cluster_mse);
appr_bias = get_appr_bias(impulse);
prim_table = get_mse(appr_bias);


end