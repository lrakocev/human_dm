%% init table

[filtered_behavior_table,prim_table] = prep_data_for_hmm("", "hum_data_oct25.mat");
%gaze_behavior_table = prep_data_for_hmm("", "human_gaze_data.mat");

id_data = group_by_feature(prim_table, "subjectidnumber");
session_data = group_same_day_stories(prim_table);
task_data = group_by_feature(prim_table, "story_type");

hmm_data = [id_data session_data task_data];


%% viz of current space

%midway_hmm_table = readtable("C:\Users\lrako\OneDrive\Documents\human_dm\hmm_trial_lvl_2_1.xlsx");

midway_hmm_table = readtable("C:\Users\lrako\OneDrive\Documents\server_output\trials\hmm_trial_lvl_4_1.xlsx");
viz = 1;

x = min(height(midway_hmm_table), 10000);
randidx = randi(height(midway_hmm_table), x, 1);

midway_hmm_rows = midway_hmm_table(randidx, :);

if viz
    human_bics = midway_hmm_rows.bic;
    mpc_1 = midway_hmm_rows.mpcs_1;
    mpc_2 = midway_hmm_rows.mpcs_2;
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

filter_t_matrices = filter_t_matrices(filter_t_matrices.mpcs_1 > 0.7, :);
filter_t_matrices = sortrows(filter_t_matrices,"bic","ascend");

ex_row = filter_t_matrices(1,:);
state_table = compare_to_og_seq(ex_row, all_data);

created_features = ["r_interact","r_impulse","mean_appr", "c_impulse", "c_interact", "sesh_var" ];

all_features = ["r_interact","r_impulse","mean_appr","max_appr",...
    "min_appr", "clusterY", "clusterZ", "a_R","b_R", "a_C", ...
    "b_C", "approach_rate", "pupil_diameter", "rew", "cost", "heart_rate", ...
    "hunger", "tiredness", "pain", "story_prefs"];
state_name = "state_2";
[Mdl] =  create_decision_tree(state_table, all_features, state_name, 0, 1);
