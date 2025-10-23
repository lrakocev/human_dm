function try_all_hmms(num_states)

% probably not loading this
load("filtered_behavior_table.mat")

id_data = group_by_feature(filtered_behavior_table, "subjectidnumber");

all_data = [id_data];
labels = [repelem("id",1,length(id_data))];

% get all combos 

granularities = 2:8;
curr_features = ["cluster_combo", "pupil_diameter", "num_saccads", "num_guesses"];

% running the hmm combos

num_tries = 100;
row_count = 0;
doc_num = 1;
excel_limit = 1000000;
file_name = "hmm_trial_lvl_" + string(num_states) +"_";

for i = 1:length(granularities)
    curr_granularity = granularities(i);

    for k = 1:length(all_data)
        input_table = all_data{k};
        id = input_table.subjectidnumber(1);
        sesh = input_table.trial_end(1);
        task = input_table.story_type(1);
        curr_label = labels(k);
    
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
            hmm_row.id = id;
            hmm_row.sesh = sesh;
            hmm_row.task = task;
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