function all_data = convert_story_types(all_data, col_name)

story_list = all_data.(col_name);

story_list(story_list == "positive") = "approach_avoid";
story_list(story_list == "mergedaa") = "approach_avoid";
story_list(story_list == "negative") = "approach_avoid";
story_list(story_list == "pqaa") = "approach_avoid";
story_list(story_list == "nqaa") = "approach_avoid";
story_list(story_list == "old_approach_avoid") = "approach_avoid";

% combine nonsense tasks
story_list(story_list == "cost_cost") = "nonsense";
story_list(story_list == "benefit_benefit") = "nonsense";

all_data.(col_name) = story_list;

end