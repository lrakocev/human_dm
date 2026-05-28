load("all_data_w_hr_w_story.mat")

all_data = all_data{1};
% adding new features based on old features

all_data.norm_saccades = all_data.num_saccads ./ all_data.q_length;
all_data.hr_range = abs(all_data.max_hr) + abs(all_data.min_hr);

all_data = unique(all_data, "rows");
%% cleaning eye tracking data

all_data.pupil_diameter(all_data.pupil_diameter == 0) = NaN;

%% positive + negative + mergedaa are all approach-avoid type stories, so relabeling

story_list = all_data.story_type;
story_list(story_list == "positive") = "approach_avoid";
story_list(story_list == "mergedaa") = "approach_avoid";
story_list(story_list == "negative") = "approach_avoid";
story_list(story_list == "pqaa") = "approach_avoid";
story_list(story_list == "nqaa") = "approach_avoid";
story_list(story_list == "old_approach_avoid") = "approach_avoid";

% combine nonsense tasks
story_list(story_list == "cost_cost") = "nonsense";
story_list(story_list == "benefit_benefit") = "nonsense";

all_data.story_type = story_list;

%% divide by story

all_story_types = unique(all_data.story_type);
for i = 1:length(all_story_types)
    story = all_story_types(i);
    all_task_data = all_data(all_data.story_type == story, :);
    split_by_task{i} = all_task_data;
end

%%

types = ["max_hr";"min_hr";"hr_range"];
base_db = "all_data_w_hr_w_story.mat";
for j = 1:length(types)
    type = types(j);
    want_bdry = 1;
    want_scale = 1;
    type_data = rmoutliers(all_data.(type));
    scale_max = max(type_data);
    scale_min = min(type_data);
    want_save = 1;
    for_ml = 0;
    path_to_save = "C:\Users\lrako\OneDrive\Documents\human_dm\final_run_2026\hr_figs_may_2026\" + type;
    mkdir(path_to_save)
    run_dec_making_plot_loop(split_by_task,all_story_types,path_to_save,want_bdry,want_scale,want_save,for_ml,base_db,type)
end

%% anova comparing tasks

task_cs = {};
base_db = "all_data_w_hr_w_story.mat";
all_story_types = unique(all_data.story_type);
types = ["max_hr"; "min_hr"; "hr_range"]; 
for j = 1:length(types)
    type = types(j);
    save_to = "C:\Users\lrako\OneDrive\Documents\human_dm\final_run_2026\all_subj_methods_anova\";
    mkdir(save_to)
    wanted_tasks = ["approach_avoid","social","probability","moral","nonsense"];
    c = comparison_btwn_tasks(split_by_task, all_story_types, wanted_tasks, type, save_to, base_db);
    task_cs{j} = c;
end

%% anova comparing rew levels 

rew_or_costs = ["rew";"cost"]; 
base_db = "all_data_w_hr_w_story.mat";
for r = 1:2
    rew_or_cost = rew_or_costs(r);
    types = ["max_hr"; "min_hr"; "hr_range"]; 
    for j = 1:length(types)
        type = types(j);
        save_to = "C:\Users\lrako\OneDrive\Documents\human_dm\final_run_2026\all_subj_methods_anova\";
        mkdir(save_to)
        wanted_tasks = ["approach_avoid","social","probability","moral","nonsense"];
        c = comparison_btwn_rew_lvls(split_by_task, all_story_types, wanted_tasks, type, rew_or_cost,save_to, base_db);
    end
end

%% anova comparing sexes

sex_counts = [];
base_db = "all_data_w_hr_w_story.mat";
types = ["max_hr"; "min_hr"; "hr_range"]; 
for j = 1:length(types)
    type = types(j);
    save_to = "C:\Users\lrako\OneDrive\Documents\human_dm\final_run_2026\all_subj_methods_sex_anova\";
    mkdir(save_to)
    [num_m, num_f] = comparison_btwn_sexes(split_by_task, ["approach_avoid"], [], type, save_to, base_db);
    sex_counts = [sex_counts; num_f num_m];
end