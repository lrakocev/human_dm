function adj_approach_data = clean_ingested_new_task(adj_results)

adj_results = removevars(adj_results,{'trial_start','reward_level','cost_level'});
adj_results = renamevars(adj_results,["decision_made","tasktypedone","trial_elapsed","tired"]...
    ,["approach_rate","story_num","timing","tiredness"]);
unique_ids = unique(adj_results.subjectidnumber);

N = length(unique_ids);
adj_approach_data = cell(1,N);
for i = 1:N
    subid = unique_ids(i);
    sub_results = adj_results(adj_results.subjectidnumber == string(subid), :);
    str_timing = string(sub_results.timing);
    timing = [];
    for j = 1:length(str_timing)
        t = str_timing(j);
        int_t = strsplit(t,":");
        timing = [timing; str2double(int_t(end))];
    end

    sub_results.timing = timing;
    sub_results.pain = str2double(sub_results.pain);
    sub_results.tiredness = str2double(sub_results.tiredness);
    sub_results.hunger = str2double(sub_results.hunger);
    sub_results.approach_rate = str2double(sub_results.approach_rate);
    sub_results.subjectidnumber = str2double(sub_results.subjectidnumber);
    sub_results.story_num = string(sub_results.story_num);
    
    adj_approach_data(i) = {sub_results};
end