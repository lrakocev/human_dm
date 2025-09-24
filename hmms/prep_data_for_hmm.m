function filtered_behavior_table = prep_data_for_hmm(home_dir,base_file_name)

load(home_dir + "clustering/alternative clustering/2d_sig_real.mat");
sig_table = renamevars(sig_table, "experiment", "story_type");

load(home_dir + base_file_name);

behavior_2d_sig_join = outerjoin(all_data, sig_table, "MergeKeys", 1, "Keys", {'subjectidnumber','story_num','story_type'});

table_name = home_dir + "july_2025/mysterious_mat/human_clusters.xlsx";
sig_table_1d_messy = readtable(table_name);

sig_table_1d = psychs_in_spec_cluster(sig_table_1d_messy,1);
sig_table_1d = renamevars(sig_table_1d, "experiment", "story_type");

behavior_sig_full = outerjoin(behavior_2d_sig_join, sig_table_1d, "MergeKeys", 1, "Keys", {'subjectidnumber','story_num','story_type','cost'});
behavior_sig_clean = behavior_sig_full(~isnan(behavior_sig_full.a_R) & ~isnan(behavior_sig_full.clusterX) & ~isnan(behavior_sig_full.approach_rate), :);

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



end