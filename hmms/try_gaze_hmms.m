%% data 

home_dir = "";
base_file_name = "human_gaze_data.mat";
filtered_behavior_table = prep_data_for_hmm(home_dir, base_file_name);
filtered_behavior_table = renamevars(filtered_behavior_table, ["num_guesses", "reaction_time"],["reaction_time", "num_guesses"]);

session_data = group_same_day_stories(filtered_behavior_table);
id_data = group_by_feature(filtered_behavior_table, "subjectidnumber");

all_data = [id_data session_data];

%% get all combos 

granularities = 2:10;
num_states = flip(2:15);
all_combos = combinations(granularities, num_states);

%% running the hmm combos

hmm_table = [];
num_tries = 500;
row_count = 0;
doc_num = 1;
excel_limit = 1000000;
file_name = "hmm_gaze_data";

for k = 1:length(all_data)
    input_table = all_data{k};

    for i = 1:height(all_combos)
        combo = all_combos(i, :);
        curr_granularity = combo.granularities;
        curr_num_states = combo.num_states;
        curr_features = ["num_guesses", "num_saccads", "reaction_time"];
        
        for j = 1:num_tries
            [states, bic, mpcs, t, e] = run_complete_hmm_process(input_table, curr_granularity, curr_features, curr_num_states);
           % hmm_row.state = states;
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

