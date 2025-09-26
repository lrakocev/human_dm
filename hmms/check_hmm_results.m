%% init table

filtered_behavior_table = prep_data_for_hmm("", "for_dirk_updated.mat");
%gaze_behavior_table = prep_data_for_hmm("", "human_gaze_data.mat");

id_data = group_by_feature(filtered_behavior_table, "subjectidnumber");
session_data = group_same_day_stories(filtered_behavior_table);
task_data = group_by_feature(filtered_behavior_table, "story_type");

all_data = [id_data session_data task_data];
%% viz of current space

midway_hmm_table = readtable("C:\Users\lrako\OneDrive\Documents\server_output\1d\hmm_1d_data_states_7_1.xlsx");
viz = 0;

x = min(height(midway_hmm_table), 10000);
randidx = randi(height(midway_hmm_table), x, 1);

midway_hmm_rows = midway_hmm_table(randidx, :);

if viz
    human_bics = midway_hmm_rows.bic;
    mpc_1 = midway_hmm_rows.mpcs;
    %mpc_2 = midway_hmm_rows.mpcs_2;
    %mpc_3 = midway_hmm_rows.mpcs_3;
    
    figure
    histogram(human_bics)
    title('1 feature bics')
    
    figure
    histogram(mpc_1)
    title('1 feature mpcs')
    
    figure
    scatter(mpc_1, human_bics)
    xlabel('mpcs')
    ylabel('bics')
    title('1 feature mpcs vs bics')
end

filter_t_matrices = midway_hmm_rows(midway_hmm_rows.t_1 > 0.01 & midway_hmm_rows.t_2 > 0.01 ...
    & midway_hmm_rows.t_3 > 0.01 & midway_hmm_rows.t_4 > 0.01, :);

filter_t_matrices = filter_t_matrices(filter_t_matrices.mpcs > 0.7, :);
filter_t_matrices = sortrows(filter_t_matrices,"bic","ascend");

ex_row = filter_t_matrices(2,:);
state_table = compare_to_og_seq(ex_row, all_data);

all_features = ["clusterY", "clusterZ", "a_R","b_R", "a_C", ...
    "b_C", "approach_rate", "pupil_diameter", "rew", "cost", "heart_rate", ...
    "hunger", "tiredness", "pain", "story_prefs"];
state_num = 1;
create_decision_tree(state_table, all_features, state_num)
