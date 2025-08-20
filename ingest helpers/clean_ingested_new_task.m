function [adj_approach_data,subject_prefs] = clean_ingested_new_task(adj_results,table_name)

adj_results = removevars(adj_results,{'trial_start','reward_level','cost_level'});
adj_results = renamevars(adj_results,["decision_made","tasktypedone","trial_elapsed","tired"]...
    ,["approach_rate","story_num","timing","tiredness"]);

if ~contains(table_name,"utep")
    adj_results = renamevars(adj_results,["hungry","age_range", "in_pain","gender"]...
        ,["hunger","age","pain","sex"]);
end

unique_ids = unique(adj_results.subjectidnumber);

N = length(unique_ids);
adj_approach_data = cell(1,N);
subject_prefs = cell(1,N);
for i = 1:N
    subid = unique_ids(i);
    sub_results = adj_results(adj_results.subjectidnumber == string(subid), :);
    sub_prefs = get_story_prefs(sub_results);
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

    if contains(table_name, "utep")
        pupil_diameter = rowfun(@clean_pupil_diam, sub_results, "InputVariables",...
            "pupil_diameter", "OutputVariableNames", "mean");
        sub_results.pupil_diameter = pupil_diameter.mean;

        heart_rate = rowfun(@clean_hr, sub_results, "InputVariables", ...
            "raw_heart_rate", "OutputVariableNames", "mean");
        sub_results.heart_rate = heart_rate.mean;
    else
        sub_results.pupil_diameter = zeros(height(sub_results),1);
        sub_results.heart_rate= zeros(height(sub_results),1);
    end
    
    subject_prefs(i) = {sub_prefs};
    adj_approach_data(i) = {sub_results};
end
end

function mean_diam = clean_pupil_diam(row)

    lvl1 = replace(string(row),'[','');
    lvl2 = str2double(split(lvl1,','));
    filtered = lvl2(lvl2 > 0);
    mean_diam = mean(filtered, 'omitnan');

end

function mean_hr = clean_hr(row)

lvl1 = replace(string(row),'[','');
lvl2 = replace(lvl1,']','');
hr_list = str2double(lvl2);
mean_hr = mean(hr_list);


end