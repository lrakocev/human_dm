function try_session_hmms(num_states)

home_dir = "";
base_file_name = "for_dirk_updated.mat";
filtered_behavior_table = prep_data_for_hmm(home_dir,base_file_name);

task_data = group_by_feature(filtered_behavior_table, "story_type");
sex_data = group_by_feature(filtered_behavior_table, "sex");

hunger_data = group_by_continuous_feature(filtered_behavior_table, "hunger");
tiredness_data = group_by_continuous_feature(filtered_behavior_table, "tiredness");
interest_data = group_by_continuous_feature(filtered_behavior_table, "story_prefs");

average_data = [task_data sex_data hunger_data interest_data tiredness_data];

labels = [repelem("task", 1, length(task_data)) repelem("sex", 1, length(sex_data))...
    repelem("hunger", 1, length(hunger_data)) repelem("interest", 1, length(interest_data)) ...
    repelem("tiredness", 1, length(task_data)) ];

granularities = num_states:num_states+4;
all_features = ["clusterX", "clusterY", "clusterZ", "a_R","b_R","a_C", ...
    "b_C", "approach_rate", "pupil_diameter", "rew", "cost", "heart_rate", ...
    "hunger", "tiredness", "pain", "story_prefs"];

% running the hmm combos

num_tries = 100;
row_count = 0;
doc_num = 1;
excel_limit = 1000000;
file_name = "hmm_average_1d_states_" + string(num_states) +"_";


for m = 1:length(all_features)
    curr_features = all_features(m);

    for i = 1:length(granularities)
        curr_granularity = granularities(i);

        for k = 1:length(average_data)
            input_table = average_data{k};
            curr_label = labels(k);
            task = input_table.story_type(1);
            sex = input_table.sex(1);
            hunger = input_table.hunger(1);
            story_pref = input_table.story_prefs(1);
            tiredness = input_table.tiredness(1);
    

            for j = 1:num_tries
                [states, bic, mpcs, t, e] = run_complete_hmm_process(input_table, curr_granularity, curr_features, num_states);
                hmm_row.bic = bic;
                hmm_row.mpcs = {mpcs};
                hmm_row.t = {t};
                hmm_row.e = {e};
                hmm_row.granularity = curr_granularity;
                hmm_row.num_states = num_states;
                hmm_row.features = curr_features;
                hmm_row.label = curr_label;
                hmm_row.sex = sex;
                hmm_row.task = task;
                hmm_row.hunger = hunger;
                hmm_row.tiredness = tiredness;
                hmm_row.interest = story_pref;
                hmm_row.actual_data_idx = k;
        
                hmm_row = struct2table(hmm_row, 'AsArray',1);
        
                row_count = row_count + 1;
                if row_count < excel_limit
                    writetable(hmm_row, file_name + string(doc_num) + ".xlsx", 'WriteMode', 'append');
                else
                    row_count = 0;
                    doc_num = doc_num + 1;
                    writetable(hmm_row, file_name + string(doc_num) + '.xlsx', 'WriteMode', 'append');
                end
        
                clear hmm_row
            end
        end
    end
end

end