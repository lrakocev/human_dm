%% data ytggfvvb
home_dir = "";
filtered_behavior_table = prep_data_for_hmm(home_dir);

id_data = group_by_feature(filtered_behavior_table, "subjectidnumber");
session_data = group_same_day_stories(filtered_behavior_table);
task_data = group_by_feature(filtered_behavior_table, "story_type");
sex_data = group_by_feature(filtered_behavior_table, "sex");

hunger_data = group_by_continuous_feature(filtered_behavior_table, "hunger");
tiredness_data = group_by_continuous_feature(filtered_behavior_table, "tiredness");
interest_data = group_by_continuous_feature(filtered_behavior_table, "story_prefs");

average_data = [task_data sex_data hunger_data interest_data tiredness_data];

%% get all combos 

granularities = 2:10;
num_states = flip(2:15);
all_features = ["clusterX", "clusterY", "clusterZ", "a_R","b_R","a_C", ...
    "b_C", "approach_rate", "pupil_diameter", "rew", "cost", "heart_rate", ...
    "hunger", "tiredness", "pain", "story_prefs"];

all_feature_combos = [];
for i = 5
    feature_combos = nchoosek(all_features, i);
    feature_cells = mat2cell(feature_combos, ones(size(feature_combos, 1), 1), i);

    all_feature_combos = [all_feature_combos; feature_cells];
end

all_combos = combinations(granularities, num_states, all_feature_combos);

%% running the hmm combos

hmm_table = [];
num_tries = 500;
row_count = 0;
doc_num = 1;
excel_limit = 1000000;
file_name = "hmm_average_data";

for k = 1:length(average_data)
    input_table = average_data{k};

    for i = 1:height(all_combos)
        combo = all_combos(i, :);
        curr_granularity = combo.granularities;
        curr_num_states = combo.num_states;
        curr_features = combo.all_feature_combos{1};

        for j = 1:num_tries
            [states, bic, mpcs, t, e] = run_complete_hmm_process(input_table, curr_granularity, curr_features, curr_num_states);
            hmm_row.bic = bic;
            hmm_row.mpcs = {mpcs};
            hmm_row.t = {t};
            hmm_row.e = {e};
            hmm_row.granularity = curr_granularity;
            hmm_row.num_states = curr_num_states;
            hmm_row.features = curr_features;
    
            hmm_row = struct2table(hmm_row, 'AsArray',1);
    
            row_count = row_count + 1;
            if row_count < excel_limit
                writetable(hmm_row, file_name + string(doc_num) + ".csv", 'WriteMode', 'append');
            else
                row_count = 0;
                doc_num = doc_num + 1;
                writetable(hmm_row, file_name + string(doc_num) + '.csv', 'WriteMode', 'append');
            end
    
            hmm_table = [hmm_table; hmm_row];
            clear hmm_row
        end
    end
end
