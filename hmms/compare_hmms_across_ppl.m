%% compare hmms across people 

%table_4d = readtable("C:\Users\lrako\OneDrive\Documents\server_output\2d2\hmm_2d_data_states_4_1.xlsx");
table_5d = readtable("C:\Users\lrako\OneDrive\Documents\server_output\2d2\hmm_2d_data_states_5_1.xlsx");
table_6d = readtable("C:\Users\lrako\OneDrive\Documents\server_output\2d2\hmm_2d_data_states_6_1.xlsx");
hmm_tables = {table_5d; table_6d};

%% step 1: pick best hmm for each person based on bic, mpc, dead states
% + fit of the states (fit of the states is difficult)
%% step 2: get definition of states per each hmm using ctree 

created_features = ["r_interact","r_impulse","mean_appr","max_appr","min_appr","mse","story_prefs" ];

special_features = ["r_interact","cluster_mse","r_impulse","mean_appr",...
    "mse", "pupil_diameter", "heart_rate","story_prefs"];

all_features = ["r_interact","cluster_mse","r_impulse","mean_appr","max_appr",...
    "min_appr","mse", "clusterY", "clusterZ", "a_R","b_R", "a_C", ...
    "b_C", "approach_rate", "pupil_diameter", "rew", "cost", "heart_rate", ...
    "hunger", "tiredness", "pain", "story_prefs"];

state_num = 1;

ids = unique(table_5d.id);
for j = 1:10 %length(ids)
    id = ids(j);
    best_hmm_row = get_best_subj_row_by_bic(hmm_tables, id);
    state_table = compare_to_og_seq(best_hmm_row, all_data);
    [Mdl] = create_decision_tree(state_table, created_features, state_num, 0);
end

% how to actually compare these trees ?? 

