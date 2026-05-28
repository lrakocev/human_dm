function [subject_lvl_task_measures] = comparison_btwn_tasks(task_data, all_story_types, wanted_tasks, type, save_to, base_db)

story_idx = find(contains(all_story_types,wanted_tasks));

subject_lvl_task_measures = {};
subjects = [];
story_order = [];
num_unique_subjects_per_task = [];
for idx = 1:length(story_idx)
    s = story_idx(idx);
    curr_task_data = task_data{s};
    story_order = [story_order; curr_task_data.story_type(1)];
    
    task_measures = [];
    unique_subjects = unique(curr_task_data.subjectidnumber);
    %num_unique_subjects_per_task = [num_unique_subjects_per_task; length(unique_subjects)];
    for j = 1:length(unique_subjects)
        subject = unique_subjects(j);

        subject_data = curr_task_data(curr_task_data.subjectidnumber == subject, :);

        subj_measure = mean(subject_data.(type), 'omitnan');
        task_measures = [task_measures; subj_measure];

    end

    num_unique_subjects_per_task = [num_unique_subjects_per_task; sum(~isnan(task_measures))];
    subjects = [subjects; unique_subjects(~isnan(task_measures))];


    subject_lvl_task_measures{idx} = task_measures;
end

writematrix(["subject level observations"], save_to + "task_comparisons.xlsx", "Range", "A2", "Sheet", type + "_task_comparisons");

anova_tasks = [];
anova_measures = [];
upperAlphabet = 'B':'Z';
for l = 1:length(subject_lvl_task_measures)
    story_type = story_order(l);
    curr_task_appr = subject_lvl_task_measures{l};

    task_data = [story_type; curr_task_appr];
    col_num = upperAlphabet(l) + "1";
    writematrix(task_data, save_to + "task_comparisons.xlsx", "Range", col_num, "Sheet", type + "_task_comparisons");

    task_name = repelem(story_type, length(curr_task_appr), 1);
    anova_tasks = [anova_tasks; task_name];
    anova_measures = [anova_measures; curr_task_appr];
end

total_subjects = unique(subjects);
[p,t,stats,terms] =  anovan(anova_measures, {anova_tasks});

cell_for_anova = length(subject_lvl_task_measures) + 2;
writecell(t, save_to + "task_comparisons.xlsx", "Range", ...
    upperAlphabet(cell_for_anova) + "1", "Sheet", type + "_task_comparisons");
    
[c, m, h, gnames] = multcompare(stats, 'CType', 'tukey-kramer');

post_hoc_tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"]);
post_hoc_tbl.("Group") = gnames(post_hoc_tbl.("Group"));
post_hoc_tbl.("Control Group") = gnames(post_hoc_tbl.("Control Group"));

writetable(post_hoc_tbl,  save_to + "task_comparisons.xlsx", "Range", ...
    upperAlphabet(cell_for_anova) + "10", "Sheet", type + "_task_comparisons");

code_info = ["test: one-way anova"; "post-hoc: tukey-kramer"; ...
    "produced by: comparison_btwn_tasks.m"; "db: load('" + base_db + "')"];
writematrix(code_info, save_to + "task_comparisons.xlsx", "Range", ...
    upperAlphabet(cell_for_anova+8) + "1", "Sheet", type + "_task_comparisons");

tbl = array2table(m,"RowNames",gnames, ...
    "VariableNames",["Mean","Standard Error"]);

boxplot(anova_measures, anova_tasks) 
hold on

empty_cells = 0;
for j = 1:height(tbl)
    samp = subject_lvl_task_measures{j};
    if ~isempty(samp)
        scatter(ones(length(samp),1)*(j - empty_cells), samp, 'filled');
    else
        empty_cells = empty_cells + 1;
    end
    hold on
end

groups = c(:,1:2);
cell_groups = num2cell(groups,2);
sigstar(cell_groups, c(:,end));
title("task diffs in " + type)
ylabel(type)
subtitle("1 way anova across task, p-value: " + p  + " with n = " + length(total_subjects) ...
    + " unique subjs across all tasks with " + strjoin(string(num_unique_subjects_per_task), ", ") + " per task respectively")

set(gcf,'renderer','Painters')
saveas(gcf,save_to + "_" + type + "task_comparisons", "fig")
saveas(gcf,save_to + "_" + type + "_task_comparisons", "svg")
end