%% data 
home_dir = "";
filtered_behavior_table = prep_data_for_hmm(home_dir);

%% get all combos 

granularities = 2:10;
num_states = 2:15;
all_features = ["clusterX", "clusterY", "clusterZ", "a_R","b_R", "a_C", ...
    "b_C", "approach_rate", "pupil_diameter", "rew", "cost", "heart_rate", ...
    "hunger", "tiredness", "pain", "story_prefs"];

all_feature_combos = [];
for i = 3
    feature_combos = nchoosek(all_features, i);
    feature_cells = mat2cell(feature_combos, ones(size(feature_combos, 1), 1), i);

    all_feature_combos = [all_feature_combos; feature_cells];
end

unique_ids = unique(filtered_behavior_table.subjectidnumber);
sessions = "session_" + unique_ids;
tasks = unique(filtered_behavior_table.story_type);
data_type = [unique_ids; tasks; sessions; "all"];

all_combos = combinations(granularities, num_states, data_type, all_feature_combos);

%% running the hmm combos

hmm_table = [];
num_tries = 1000;
row_count = 0;
doc_num = 1;
excel_limit = 1000000;
for i = 1:height(all_combos)
    combo = all_combos(i, :);
    curr_granularity = combo.granularities;
    curr_num_states = combo.num_states;
    curr_features = combo.all_feature_combos{1};
    curr_data_type = combo.data_type;

    for j = 1:num_tries
        [states, bic, mpcs, t, e] = run_complete_hmm_process(filtered_behavior_table, curr_data_type, curr_granularity, curr_features, curr_num_states);
       % hmm_row.state = states;
        hmm_row.bic = bic;
        hmm_row.mpcs = {mpcs};
        hmm_row.t = {t};
        hmm_row.e = {e};
        hmm_row.granularity = curr_granularity;
        hmm_row.num_states = curr_num_states;
        hmm_row.features = curr_features;
        hmm_row.data_type = curr_data_type;

        hmm_row = struct2table(hmm_row, 'AsArray',1);

        row_count = row_count + 1;
        if row_count < excel_limit
            writetable(hmm_row, 'hmm_data_' + doc_num + '.csv', 'WriteMode', 'append');
        else
            row_count = 0;
            doc_num = doc_num + 1;
            writetable(hmm_row, 'hmm_data_' + doc_num + '.csv', 'WriteMode', 'append');
        end

        hmm_table = [hmm_table; hmm_row];
        clear hmm_row
    end
end

save("hmm_workspace.mat")
