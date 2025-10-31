function trial_table = add_category(trial_table, story_category_file)

story_category = readtable(story_category_file);
get_category_func = @(type,num) get_category(type, num, story_category);

story_table = rowfun(get_category_func, trial_table, "InputVariables", ...
            ["story_type", "story_num"], "NumOutputs", 1, "OutputVariableNames", {'category'});

trial_table.story_category = story_table.category;


end

function category = get_category(type, num, story_category)

story_num = split(num, "_");
num_cleaned = story_num(2);


category = story_category(story_category.story_type == type & ...
    story_category.story_num == str2double(num_cleaned), :).category;

try
    category = category(1);
catch
    category = "unlabeled";
end

end