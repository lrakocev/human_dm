function [total_subjects] = comparison_btwn_rew_lvls(lvl_data, all_story_types, wanted_tasks, type, rew_or_cost, save_to, base_db)

story_idx = find(contains(all_story_types,wanted_tasks));

all_data_together = [];
for j = 1:length(lvl_data)
    if ismember(j, story_idx)
        all_data_together = [all_data_together; lvl_data{j}];
    end
end

subject_lvl_rs = {};
subjects = [];

unique_subjects = unique(all_data_together.subjectidnumber);

for r = 1:4
    curr_rew_lvl = all_data_together(all_data_together.(rew_or_cost) == r, :);

    rew_lvl_measures = [];

    for j = 1:length(unique_subjects)
        subject = unique_subjects(j);
        subject_rew_data = curr_rew_lvl(curr_rew_lvl.subjectidnumber == subject, :);

        subj_measure = mean(subject_rew_data.(type), 'omitnan');
        rew_lvl_measures = [rew_lvl_measures; subj_measure];
        if ~isnan(subj_measure)
            subjects = [subjects; subject];
        end
    end

subject_lvl_rs{r} = rew_lvl_measures;
end

writematrix(["subject level observations"], save_to + rew_or_cost + ...
    "_lvl_comparisons.xlsx", "Range", "A2", "Sheet", type + "_" + rew_or_cost + "_comparisons");

anova_rs = [];
anova_measures = [];
upperAlphabet = 'B':'Z';
for l = 1:4
    curr_rew_lvl_measure = subject_lvl_rs{l};

    lvl_data = ["level: " + string(l); curr_rew_lvl_measure];
    col_num = upperAlphabet(l) +  "1";
    writematrix(lvl_data, save_to + rew_or_cost + "_lvl_comparisons.xlsx", "Range", col_num, "Sheet", type + "_" + rew_or_cost + "_comparisons");
    
    rew_lvl_name = repelem(l, length(curr_rew_lvl_measure), 1);
    anova_rs = [anova_rs; rew_lvl_name];
    anova_measures = [anova_measures; curr_rew_lvl_measure];
end

total_subjects = unique(subjects);
[p,t,stats,terms] =  anovan(anova_measures, {anova_rs});

cell_for_anova = 6;
writecell(t, save_to + rew_or_cost + "_lvl_comparisons.xlsx", "Range", ...
    upperAlphabet(cell_for_anova) + "1", "Sheet", type + "_" + rew_or_cost + "_comparisons")
    
    
[c, m, h, gnames] = multcompare(stats, 'CType', 'tukey-kramer');

post_hoc_tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"]);
post_hoc_tbl.("Group") = gnames(post_hoc_tbl.("Group"));
post_hoc_tbl.("Control Group") = gnames(post_hoc_tbl.("Control Group"));

writetable(post_hoc_tbl,  save_to + rew_or_cost + "_lvl_comparisons.xlsx", "Range", ...
    upperAlphabet(cell_for_anova) + "10", "Sheet", type + "_" + rew_or_cost + "_comparisons");

code_info = ["test: one-way anova"; "post-hoc: tukey-kramer"; ...
    "produced by: comparison_btwn_rew_lvls.m"; "db: load('" + base_db + "')"];
writematrix(code_info,save_to + rew_or_cost + "_lvl_comparisons.xlsx", "Range", ...
    upperAlphabet(cell_for_anova+8) + "1", "Sheet", type + "_" + rew_or_cost + "_comparisons");


tbl = array2table(m,"RowNames",gnames, ...
    "VariableNames",["Mean","Standard Error"]);

boxplot(anova_measures,anova_rs)
hold on
%errorbar(1:height(tbl), tbl.Mean', tbl.("Standard Error")')
%hold on

empty_cells = 0;
for j = 1:height(tbl)
    samp = subject_lvl_rs{j};
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
xticklabels(1:4)
title(rew_or_cost + " lvl diffs in " + type + " with n = " + length(total_subjects) + " unique subjs across all tasks")
ylabel(type)
subtitle("1 way anova across " + rew_or_cost + ", p-value: " + p)
set(gcf,'renderer','Painters')
saveas(gcf,save_to + "_" + type + "_" + rew_or_cost + "_lvl_comparisons", "fig")
saveas(gcf,save_to + "_" + type + "_" + rew_or_cost + "_lvl_comparisons", "svg")
end