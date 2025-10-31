%% compare hmms across people 

%[filtered_behavior_table,prim_table] = prep_data_for_hmm("", "for_dirk_updated.mat");
%gaze_behavior_table = prep_data_for_hmm("", "human_gaze_data.mat");

load("hum_data_oct25.mat")
%prim_table = add_prims_to_table(all_data);

%joined_data = outerjoin(all_data, prim_table, "MergeKeys", 1, "Keys",  {'subjectidnumber','story_num','story_type'});

id_data = group_by_feature(all_data, "subjectidnumber");


%%

base_dir = "C:\Users\lrako\OneDrive\Documents\server_output\trials";
%table_3d = readtable(base_dir + "\hmm_trial_lvl_3_1.xlsx");
%able_4d = readtable(base_dir + "\hmm_trial_lvl_4_1.xlsx");
table_5d = readtable(base_dir + "\hmm_trial_lvl_5_1.xlsx");
table_6d = readtable(base_dir + "\hmm_trial_lvl_6_1.xlsx");
table_7d = readtable(base_dir + "\hmm_trial_lvl_7_1.xlsx");

%%
table_5d = table_5d(~isnan(table_5d.id) & table_5d.id > 1, :);
table_6d = table_6d(~isnan(table_6d.id) & table_6d.id > 1, :);
table_7d = table_7d(~isnan(table_7d.id) & table_7d.id > 1, :);

hmm_tables = { table_5d; table_6d; table_7d};

%% step 1: pick best hmm for each person based on bic, mpc, dead states
% + fit of the states (fit of the states is difficult)
%% step 2: get definition of states per each hmm using ctree 

created_features = ["pupil_diameter", "approach_rate",...
    "rew", "cost", "reaction_time", "num_guesses", "num_saccads"]; 

%    "r_interact","r_impulse"];

all_features = ["r_interact","cluster_mse","r_impulse","mean_appr","max_appr",...
    "min_appr","mse", "clusterY", "clusterZ", "a_R","b_R", "a_C", ...
    "b_C", "approach_rate", "pupil_diameter", "rew", "cost", "heart_rate", ...
    "hunger", "tiredness", "pain", "story_prefs"];

state_var = "state_1";

all_people_state_table = [];
ids = unique(table_5d.id);
best_hmms = {};
for j = 1 : length(ids)
    id = ids(j);
    try
        best_hmm_row = get_best_subj_row_by_bic(hmm_tables, all_data, id);
        best_hmms{j} = best_hmm_row;
    
        state_table = compare_to_og_seq(best_hmm_row, all_data);

        state_1_num_states = length(unique(state_table.state_1));
        state_2_num_states = length(unique(state_table.state_2));

        if state_2_num_states < state_1_num_states
            state_var = "state_1";
        else 
            state_var = "state_2";
        end

        define_states_via_spider(state_table, created_features, state_var, 1)
        %[Mdl] = create_decision_tree(state_table, created_features, state_var, 0, 1);
        %state_description_table = describe_leaf_nodes(Mdl);
        %all_people_state_table = [all_people_state_table; state_description_table];
    catch
        continue
    end
end

%% best hmms

num_states = [];
bics = [];
mpcs = [];
for i = 1:length(best_hmms)
    curr_hmm = best_hmms{i};
    if ~isempty(curr_hmm)
        bics = [bics; curr_hmm.bic];
        mpcs = [mpcs; curr_hmm.mpcs_1];
        num_states = [num_states; curr_hmm.num_states];
    end
end

figure
histogram(bics)
title("bics of best hmms")

figure
histogram(mpcs)
title("mpcs of best hmms")

figure
scatter(mpcs, bics)
xlabel("mpc")
ylabel("bic")

%%

all_hmm_states = [];
for k = 1 : length(best_hmms)
    curr_hmm = best_hmms{k};
    if ~isempty(curr_hmm)
        state_table = compare_to_og_seq(curr_hmm, all_data);
    
        state_1_num_states = length(unique(state_table.state_1));
            state_2_num_states = length(unique(state_table.state_2));
    
            if state_2_num_states < state_1_num_states
                state_var = "state_1";
            else 
                state_var = "state_2";
            end
    
        all_state_mean = define_states_via_spider(state_table, created_features, state_var, 0);
        all_hmm_states = [all_hmm_states; all_state_mean];
    end
end

all_hmm_states_table = array2table(all_hmm_states, 'VariableNames', created_features);

%% find clusters 

graphed_feats = ["num_guesses", "reaction_time", "approach_rate"];
clustered_feats = {'pupil_diameter','approach_rate','reaction_time','num_guesses'};
all_mpcs = [];

non_nan_hmm_tble = all_hmm_states_table(~isnan(all_hmm_states_table.pupil_diameter), :);

combos = nchoosek(all_hmm_states_table.Properties.VariableNames, 2);
for j = 1:length(combos) % 3: 40
    combo = combos(j,:);
    feat1 = combo{1};
    feat2 = combo{2};


    figure
    scatter(non_nan_hmm_tble.(feat1),non_nan_hmm_tble.(feat2) )
    xlabel(feat1)
    ylabel(feat2)
    
     %mpc = try_clustering_hmm_states(all_hmm_states_table, j, clustered_feats, graphed_feats, 1);
     %all_mpcs = [all_mpcs; mpc];
end


%figure
%bar(3:40, all_mpcs)