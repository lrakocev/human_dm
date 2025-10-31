function try_trial_hmms(num_states)

load("new_human_data_nov25.mat")

id_data = group_by_feature(all_data, "subjectidnumber");

all_data = [id_data];
labels = [repelem("id",1,length(id_data))];

% get all combos 

granularities = 2:3;
all_features = ["approach_rate", "pupil_diameter", "num_saccads", "num_guesses", "reaction_time"];

all_feature_combos = [];
for c = 1:length(all_features)
    feature_combos = nchoosek(all_features, c);
    feature_cells = mat2cell(feature_combos, ones(size(feature_combos, 1), 1), c);
    all_feature_combos = [all_feature_combos; feature_cells];
end

% running the hmm combos

num_tries = 100;
row_count = 0;
doc_num = 1;
excel_limit = 1000000;
file_name = "hmm_trial_lvl_feats_" + string(num_states) +"_";

for m = 1:length(feature_combos)
    curr_features = all_feature_combos{m,:};

    for i = 1:length(granularities)
        curr_granularity = granularities(i);
    
        for k = 1:length(all_data)
            input_table = all_data{k};
            id = input_table.subjectidnumber(1);
            sesh = input_table.trial_end(1);
            task = input_table.story_type(1);
            curr_label = labels(k);

            et_is_empty = sum(isnan(input_table.pupil_diameter)) > height(input_table) * 0.10;
            uses_et_features = sum(contains(curr_features, ["num_saccads", "num_guesses", "pupil_diameter", "reaction_time"])) > 0;
            if et_is_empty && uses_et_features
                continue
            end
                    
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


end