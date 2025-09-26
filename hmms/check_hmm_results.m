%% init table

filtered_behavior_table = prep_data_for_hmm("", "for_dirk_updated.mat");
gaze_behavior_table = prep_data_for_hmm("", "human_gaze_data.mat");

%% viz of current space

midway_hmm_table = readtable("C:\Users\lrako\OneDrive\Documents\hmm_data.csv");
%midway_hmm_table = readtable("C:\Users\lrako\OneDrive\Documents\human_dm\hmms\hmm_gaze_data1.xlsx", "NumHeaderLines",1);

%%
x = 10000;
randidx = randi(height(midway_hmm_table), x, 1);

midway_hmm_rows = midway_hmm_table(randidx, :);

human_bics = midway_hmm_rows.bic;
mpc_1 = midway_hmm_rows.mpcs_1;
mpc_2 = midway_hmm_rows.mpcs_2;
mpc_3 = midway_hmm_rows.mpcs_3;

%% 
figure
histogram(human_bics)
title('3 feature bics')

figure
histogram(mpc_1)
hold on
histogram(mpc_2)
hold on
histogram(mpc_3)
title('3 feature mpcs')
hold off

figure
scatter(mpc_1, human_bics)
xlabel('mpcs')
ylabel('bics')
title('3 feature mpcs vs bics')

%%
filter_t_matrices = midway_hmm_rows(midway_hmm_rows.t_1 > 0.01 & midway_hmm_rows.t_2 > 0.01 ...
    & midway_hmm_rows.t_3 > 0.01 & midway_hmm_rows.t_4 > 0.01, :);

filter_t_matrices = filter_t_matrices(filter_t_matrices.mpcs_1 > 0.9 | filter_t_matrices.mpcs_2 > 0.9 | filter_t_matrices.mpcs_3 > 0.9, :);
filter_t_matrices = sortrows(filter_t_matrices,"bic","ascend");

ex_row = head(filter_t_matrices,1);

%%
state_table = compare_to_og_seq(ex_row, filtered_behavior_table);
%state_gaze_table = compare_to_og_seq(ex_row, gaze_behavior_table);

%%
all_features = ["clusterX", "clusterY", "clusterZ", "a_R","b_R", "a_C", ...
    "b_C", "approach_rate", "pupil_diameter", "rew", "cost", "heart_rate", ...
    "hunger", "tiredness", "pain", "story_prefs"];
state_num = 1;
create_decision_tree(state_table, all_features, state_num)
