subid = 30401;
story_type = "approach_avoid";
story_num = "story_12";

ex_table = all_data(all_data.subjectidnumber == subid & ...
    all_data.story_type == story_type & ...
    all_data.story_num == story_num, :);

cleaned_table = [];
for r = 1:4
    for c = 1:4
        r_c_table = ex_table(ex_table.rew == r & ex_table.cost == c, :);
        r_c_table.approach_rate = repelem(mean(r_c_table.approach_rate), height(r_c_table), 1);

        cleaned_table = [cleaned_table; r_c_table(1,:)];
    end
end

path_to_save = 'C:\Users\lrako\OneDrive\Documents\human_dm\final_run_2026\ex_for_raquel\';
type = "approach rate";

avg_psychometric_across_levels({cleaned_table}, type, "cost", story_type, [1, 0, 0], path_to_save,1)

avg_psychometric_across_levels({cleaned_table}, type, "rew", story_type, [1, 0, 0], path_to_save,1)

plot_individual_psychs_across_lvls({cleaned_table}, "cost", story_type, path_to_save)%

plot_individual_psychs_across_lvls({cleaned_table}, "rew", story_type, path_to_save)

subj_table = cleaned_table(:, {'subjectidnumber','story_type','story_num','rew','cost','approach_rate'});
writetable(subj_table, path_to_save + "indiv_examples.xlsx", "Range", "A1", "Sheet", subid + "_" + story_type)