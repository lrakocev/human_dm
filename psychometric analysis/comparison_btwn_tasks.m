function [total_subjects] = comparison_btwn_tasks(task_data, r_ratings, wanted_tasks, save_to)

all_story_types = unique(r_ratings.tasktype);
story_idx = find(contains(all_story_types,wanted_tasks));

subject_lvl_task_apprs = {};
subject_lvl_task_rs = {};
subject_lvl_task_cs = {};
subjects = [];
for idx = 1:length(story_idx)
    s = story_idx(idx);
    curr_task_data = task_data{s};
    
    task_apprs = [];
    task_rs = [];
    task_cs = [];
    unique_subjects = unique(curr_task_data.subjectidnumber);
    subjects = [subjects; unique_subjects];
    for j = 1:length(unique_subjects)
        subject = unique_subjects(j);
        subject_data = curr_task_data(curr_task_data.subjectidnumber == subject, :);
    
        apprs = [];
        rs = [];
        cs = [];
        for r = 1:4
            for c = 1:4
                appr = mean(subject_data(subject_data.rew == r & subject_data.cost == c, :).approach_rate, 'omitnan');
                apprs = [apprs; appr];
                rs = [rs; r];
                cs = [cs; c];
            end
        end
        task_rs = [task_rs; rs];
        task_cs = [task_cs; cs];
        task_apprs = [task_apprs; apprs];
    end

    subject_lvl_task_apprs{idx} = task_apprs;
    subject_lvl_task_rs{idx} = task_rs;
    subject_lvl_task_cs{idx} = task_cs;
end

anvova_tasks = [];
anova_rs = [];
anova_cs = [];
anova_apprs = [];
for l = 1:length(subject_lvl_task_cs)
    story_type = wanted_tasks(l);
    curr_task_appr = subject_lvl_task_apprs{l};
    curr_task_r = subject_lvl_task_rs{l};
    curr_task_c = subject_lvl_task_cs{l};

    task_name = repelem(story_type, length(curr_task_appr), 1);
    anvova_tasks = [anvova_tasks; task_name];
    anova_rs = [anova_rs; curr_task_r];
    anova_cs = [anova_cs; curr_task_c];
    anova_apprs = [anova_apprs; curr_task_appr];
end

total_subjects = unique(subjects);
[p,t,stats,terms] =  anovan(anova_apprs, {anvova_tasks;anova_rs;anova_cs},'model','interaction','varnames',{'task','rew','cost'});
    
[c, m, h, gnames] = multcompare(stats, 'CType', 'tukey-kramer');

tbl = array2table(m,"RowNames",gnames, ...
    "VariableNames",["Mean","Standard Error"]);

bar(1:height(tbl), tbl.Mean')
hold on
errorbar(1:height(tbl), tbl.Mean', tbl.("Standard Error")')
hold on
groups = c(:,1:2);
cell_groups = num2cell(groups,2);
sigstar(cell_groups, c(:,end));
xticklabels(wanted_tasks)
set(gcf,'renderer','Painters')
saveas(gcf,save_to + "task_comparisons", "fig")
saveas(gcf,save_to + "_task_comparisons", "svg")
end