function filtered_files = filter_helper(clean_approach_data, subject_prefs, thresh, by_cost)

[pref_approach_data] = add_pref_column(clean_approach_data, subject_prefs, thresh);

% add new column for story type 
[approach_data] = add_story_column_loop(pref_approach_data);

tot = [];
for i = 1:length(approach_data)
    tot = [tot; approach_data{1,i}];
end

if by_cost
    tot.psych_file = tot.story_type + "/Sigmoid Data/" + tot.subjectidnumber + "_" + tot.story_num + "_cost_" + string(tot.cost) + ".mat";
else   
    tot.psych_file = tot.story_type + "/Sigmoid Data/" + tot.subjectidnumber + "_" + tot.story_num + ".mat";
end

filtered_files = unique(tot.psych_file);
end
