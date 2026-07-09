function [num_m, num_f] = comparison_btwn_sexes(task_data, all_story_types, wanted_tasks, type, save_to, base_db)

if ~isempty(wanted_tasks)
    story_idx = find(contains(all_story_types,wanted_tasks));
else
    story_idx = [1];
end

all_female_subjects = [];
all_male_subjects = [];
female_subject_lvl_task_measures = {};
male_subject_lvl_task_measures = {};
for idx = 1:length(story_idx)
    s = story_idx(idx);
    curr_task_data = task_data{s};
    
    female_task_measure = [];
    male_task_measure = [];

    female_subjects = unique(curr_task_data(curr_task_data.sex == "female", :).subjectidnumber);
    male_subjects = unique(curr_task_data(curr_task_data.sex == "male", :).subjectidnumber);

    for j = 1:length(female_subjects)
        subject = female_subjects(j);
        subject_data = curr_task_data(curr_task_data.subjectidnumber == subject, :);
   
        subj_measure = mean(subject_data.(type), 'omitnan');
        female_task_measure = [female_task_measure; subj_measure];
    end

    for j = 1:length(male_subjects)
        subject = male_subjects(j);
        subject_data = curr_task_data(curr_task_data.subjectidnumber == subject, :);
   
        subj_measure = mean(subject_data.(type), 'omitnan');
        male_task_measure = [male_task_measure; subj_measure];
    end

    male_task_measure_no_nans = male_task_measure(~isnan(male_task_measure));
    female_task_measure_no_nans = female_task_measure(~isnan(female_task_measure));

    smaller_set = min(length(male_task_measure_no_nans), length(female_task_measure_no_nans));
    if length(female_task_measure_no_nans) > smaller_set 
        rng('default');
        rand_f_subjs = randperm(length(female_task_measure_no_nans), smaller_set);
        female_task_measure_no_nans = female_task_measure_no_nans(rand_f_subjs);
        female_subjects = female_subjects(rand_f_subjs);
        male_subjects = male_subjects(~isnan(male_task_measure));
    elseif length(male_task_measure_no_nans) > smaller_set 
        rng('default');
        rand_m_subjs = randperm(length(male_task_measure_no_nans), smaller_set);
        male_task_measure_no_nans = male_task_measure_no_nans(rand_m_subjs);
        male_subjects = male_subjects(rand_m_subjects);
        female_subjects = female_subjects(~isnan(female_task_measure));

    end

    all_female_subjects = [all_female_subjects; female_subjects];
    all_male_subjects = [all_male_subjects; male_subjects];

    female_subject_lvl_task_measures{idx} = female_task_measure_no_nans;
    male_subject_lvl_task_measures{idx} = male_task_measure_no_nans;


end

num_m = length(unique(all_male_subjects));
num_f = length(unique(all_female_subjects));

file_name = save_to + "sex_comparisons.xlsx";
sheet_name = type + "_sex_comparisons";

writematrix(["subject level observations"],file_name, ...
    "Range", "A2", "Sheet",  sheet_name);


upperAlphabet = 'B':'Z';

anvova_tasks = [];
anova_measures = [];
anova_sexes = [];
for l = 1:length(female_subject_lvl_task_measures)
    if ~isempty(wanted_tasks)
        story_type = wanted_tasks(l);
    else
        story_type = "all";
    end
    curr_task_appr = female_subject_lvl_task_measures{l};

    curr_data = ["female+" + story_type ; curr_task_appr];
    col_num = upperAlphabet(l) +  "1";
    writematrix(curr_data, file_name, ...
        "Range", col_num, "Sheet", sheet_name);
   
    task_name = repelem(story_type, length(curr_task_appr), 1);
    anvova_tasks = [anvova_tasks; task_name];
    anova_measures = [anova_measures; curr_task_appr];
    anova_sexes = [anova_sexes;  repelem("female", length(curr_task_appr), 1)];
end

for l = 1:length(male_subject_lvl_task_measures)   
    if ~isempty(wanted_tasks)
        story_type = wanted_tasks(l);
    else
        story_type = "all";
    end    
    curr_task_appr = male_subject_lvl_task_measures{l};

    curr_data = ["male+" + story_type ; curr_task_appr];
    alphabet_ind = l + length(female_subject_lvl_task_measures);
    col_num = upperAlphabet(alphabet_ind) +  "1";
    writematrix(curr_data,file_name, ...
        "Range", col_num, "Sheet",sheet_name);
    
    task_name = repelem(story_type, length(curr_task_appr), 1);
    anvova_tasks = [anvova_tasks; task_name];
    anova_measures = [anova_measures; curr_task_appr];
    anova_sexes = [anova_sexes;  repelem("male", length(curr_task_appr), 1)];
end

[h,p] =  ttest(female_subject_lvl_task_measures{:}, male_subject_lvl_task_measures{:});

cell_for_anova = length(female_subject_lvl_task_measures) + length(male_subject_lvl_task_measures) + 2;
writematrix(["p-value: " + string(p)], file_name, "Range", ...
    upperAlphabet(cell_for_anova) + "1", "Sheet", sheet_name)
    
code_info = ["test: t-test"; ...
    "produced by: comparison_btwn_sexes.m"; "db: load('" + base_db + "')"];
writematrix(code_info, file_name, "Range", ...
    upperAlphabet(cell_for_anova+2) + "1", "Sheet", sheet_name);

figure
boxplot(anova_measures,anova_sexes)
hold on
%errorbar(1:height(tbl), tbl.Mean', tbl.("Standard Error")')
%hold on
xticklabels(["female" ; "male"]);
empty_cells = 0;
for j = 1:length(female_subject_lvl_task_measures)
    samp = female_subject_lvl_task_measures{j};
    if ~isempty(samp)
        scatter(ones(length(samp),1)*(j - empty_cells), samp, 'filled');
    else
        empty_cells = empty_cells + 1;
    end
    hold on
end

for j = 1:length(male_subject_lvl_task_measures)
    samp = male_subject_lvl_task_measures{j};
    if ~isempty(samp)
        num = length(female_subject_lvl_task_measures) + j;
        scatter(ones(length(samp),1)*(num - empty_cells), samp, 'filled');
    else
        empty_cells = empty_cells + 1;
    end
    hold on
end

title("task and sex diffs " + type + ", num f subj: " + num_f  + " and num m subj: " + num_m)
ylabel(type)
subtitle("ttest , p-value: " + p)
set(gcf,'renderer','Painters')
saveas(gcf,save_to + type + "_sex_task_comparisons", "fig")
saveas(gcf,save_to + type + "_sex_task_comparisons", "svg")
close all
end