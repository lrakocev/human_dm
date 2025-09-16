%% loading the various data sources

load("C:\Users\lrako\OneDrive\Documents\human dm\for_dirk_updated.mat");
load("C:\Users\lrako\OneDrive\Documents\human dm\clustering\alternative clustering\2d_sig_real.mat");
sig_table = renamevars(sig_table, "experiment", "story_type");

behavior_2d_sig_join = outerjoin(all_data, sig_table, "MergeKeys", 1, "Keys", {'subjectidnumber','story_num','story_type'});

table_name = "C:\Users\lrako\OneDrive\Documents\human dm\july_2025\human_clusters.xlsx";
sig_table_1d_messy = readtable(table_name);

sig_table_1d = psychs_in_spec_cluster(sig_table_1d_messy,1);
sig_table_1d = renamevars(sig_table_1d, "experiment", "story_type");

behavior_sig_full = outerjoin(behavior_2d_sig_join, sig_table_1d, "MergeKeys", 1, "Keys", {'subjectidnumber','story_num','story_type','cost'});
behavior_sig_clean = behavior_sig_full(~isnan(behavior_sig_full.a_R) & ~isnan(behavior_sig_full.clusterX) & ~isnan(behavior_sig_full.approach_rate), :);

%% 
num_trials_for_thresh = 16*4;
filtered_behavior_table = [];
unique_ids = unique(behavior_sig_clean.subjectidnumber);
for i = 1:length(unique_ids)
    id = unique_ids(i);
    subject_table = behavior_sig_clean(behavior_sig_clean.subjectidnumber == id, :);
    if height(subject_table) > num_trials_for_thresh;
        filtered_behavior_table = [filtered_behavior_table; subject_table];
    end
end

%% create states + make the table above a sequence of those states

% TODO: concat table across suitable subjects ?
% TODO: vary granularity
subject_id = 13284;
granularity = 3;
features = ["approach_rate", "pupil_diameter", "rew", "cost", "a_R"];
seq_table = get_sequence_for_hmm(behavior_sig_clean, features, granularity, subject_id, 0);
%state_seq = convert_seqs_to_state(seq_table);

%%

% TODO: vary # states
% TODO: try many initializations of E and T matrices
num_states = 2;
estimate_t = rand(num_states);
estimate_t = estimate_t ./ sum(estimate_t, 2);

estimate_e = rand(num_states, granularity);
estimate_e = estimate_e ./ sum(estimate_e, 2); 

[states, bic, mpcs, t, e] = run_hmm(seq_table, estimate_t, estimate_e);

