function [adj_approach_data,subject_prefs] = clean_ingested_new_task(adj_results,table_name,trial_word_length)

adj_results.reward_level = string(adj_results.reward_level);
adj_results.cost_level = string(adj_results.cost_level);
joined_results = outerjoin(adj_results, trial_word_length, 'MergeKeys', 1, 'Keys', ["reward_level","cost_level","tasktypedone"]);
filtered_join = joined_results(joined_results.subjectidnumber ~= "" & joined_results.rew ~= 0, :);

filtered_join = removevars(filtered_join,{'reward_level','cost_level'});
filtered_join = renamevars(filtered_join,["decision_made","tasktypedone","trial_elapsed","tired"]...
    ,["approach_rate","story_num","timing","tiredness"]);

if ~contains(table_name,"utep")
    filtered_join = renamevars(filtered_join,["hungry","age_range", "in_pain","gender"]...
        ,["hunger","age","pain","sex"]);
end

unique_ids = unique(filtered_join.subjectidnumber);

N = length(unique_ids);
adj_approach_data = cell(1,N);
subject_prefs = cell(1,N);
for i = 1:N
    subid = unique_ids(i);
    sub_results = filtered_join(filtered_join.subjectidnumber == string(subid), :);
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
            "raw_heart_rate", "NumOutputs", 4, "OutputVariableNames", {'mean_hr', 'max_hr', 'min_hr','direction'});
        sub_results.mean_hr = heart_rate.mean_hr;
        sub_results.max_hr = heart_rate.max_hr;
        sub_results.min_hr = heart_rate.min_hr;
        sub_results.direction = heart_rate.direction;


        gaze_data = rowfun(@clean_gaze, sub_results, "InputVariables", ...
            ["left_gaze_coords", "q_length"], "NumOutputs",3, "OutputVariableNames", {'reaction','num_guesses','saccads'});
        sub_results.reaction_time = gaze_data.reaction;
        sub_results.num_guesses = gaze_data.num_guesses;
        sub_results.num_saccads = gaze_data.saccads;

        sub_results.left_gaze_coords = [];
        
    else
        sub_results.pupil_diameter = zeros(height(sub_results),1);
        sub_results.raw_heart_rate = zeros(height(sub_results),1);

        sub_results.reaction_time = zeros(height(sub_results),1);
        sub_results.num_saccads = zeros(height(sub_results),1);
        sub_results.num_guesses = zeros(height(sub_results),1);  

        sub_results.mean_hr = zeros(height(sub_results),1);
        sub_results.max_hr = zeros(height(sub_results),1);
        sub_results.min_hr = zeros(height(sub_results),1);
        sub_results.direction = zeros(height(sub_results),1);
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

function [mean_hr, max_hr, min_hr, direction] = clean_hr(row)

lvl1 = replace(string(row),'[','');
lvl2 = replace(lvl1,']','');
split_list = split(lvl2, ",");
hr_list = str2double(split_list);
mean_hr = mean(hr_list, 'omitnan');
max_hr = (max(hr_list) - mean_hr) / mean_hr;
min_hr = (min(hr_list) - mean_hr) / mean_hr;

if ~isempty(hr_list)
    if hr_list(end) > hr_list(1)
        direction = 1;
    else
        direction = -1;
    end
else
    direction = 0;
end
end

function [reaction,guesses,saccads] = clean_gaze(coords, length)

lvl1 = replace(string(coords),'[','');
lvl2 = replace(lvl1,']','');
split_list = split(lvl2, ",");
gaze_list = str2double(split_list);

if ~isnan(gaze_list)
    reshaped = reshape(gaze_list, 2, [])'; 
    try
       % [~,location] = calc_reaction_time(reshaped, length);
        [guesses,reaction] = calc_num_guesses(reshaped,length);
        [saccads] = calc_num_saccads(reshaped);       
    catch
        reaction = 0;
        guesses = 0;
        saccads = 0;
    end
else
    guesses = 0;
    reaction = 0;
    saccads = 0;
end

end