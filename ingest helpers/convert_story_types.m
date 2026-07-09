function all_data = convert_story_types(all_data, col_name, story_categories_file)

story_categories = readtable(story_categories_file);
story_categories.story_num = "story_" + story_categories.story_num ;
story_categories.category = string(story_categories.category);

nonsense_non_ap_av = story_categories(story_categories.story_type ~= "approach_avoid" & ...
    story_categories.category == "bad", :).story_num;

nonsense_ap_av = "story_" + nonsense_non_ap_av;

all_data_w_categories = outerjoin(all_data, story_categories, "MergeKeys", 1, "Keys", {'story_num','story_type'});
   
all_data_w_categories = all_data_w_categories(~isnan(all_data_w_categories.subjectidnumber), :);

bad_story_idx = (all_data_w_categories.category == "bad") & (all_data_w_categories.story_type == "multichoice");

story_list = all_data.(col_name);

% have to do this first before converting the other story types to ap av

story_list(story_list == "positive") = "approach_avoid";
story_list(story_list == "mergedaa") = "approach_avoid";
story_list(story_list == "negative") = "approach_avoid";
story_list(story_list == "pqaa") = "approach_avoid";
story_list(story_list == "nqaa") = "approach_avoid";
story_list(story_list == "old_approach_avoid") = "approach_avoid";

% combine nonsense tasks
story_list(story_list == "cost_cost") = "nonsense";
story_list(story_list == "benefit_benefit") = "nonsense";
story_list(story_list == "multichoice") = "nonsense";

story_list(bad_story_idx) = "nonsense";

all_data.(col_name) = story_list;

end