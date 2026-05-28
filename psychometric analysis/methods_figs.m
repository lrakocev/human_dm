load("full_ingest_w_leftovers_may_2026!.mat")

[incomplete_session_appr_data_w_story] = add_story_column_loop(incomplete_session_appr_data);

all_trials_w_incomplete = [all_trial_data incomplete_session_appr_data_w_story];
all_data = [];
for j = 1:length(all_trials_w_incomplete)
    curr_data = all_trials_w_incomplete{j} ;
    if ~isempty(curr_data)
        curr_data.raw_heart_rate = [];
        curr_data.story_prefs = [];
        if ismember('left_pupil_diameter', curr_data.Properties.VariableNames)
            curr_data.left_pupil_diameter = [];
        end
        if ismember('reward_level', curr_data.Properties.VariableNames)
            curr_data.reward_level = [];
            curr_data.cost_level = [];
        end
        all_data = [all_data; curr_data];
    end
end

% adding new features based on old features

all_data.norm_saccades = all_data.num_saccads ./ all_data.q_length;
all_data.hr_range = abs(all_data.max_hr) + abs(all_data.min_hr);

all_data = unique(all_data, "rows");
%% cleaning eye tracking data

all_data.pupil_diameter(all_data.pupil_diameter == 0) = NaN;

%% positive + negative + mergedaa are all approach-avoid type stories, so relabeling

all_data = convert_story_types(all_data, "story_type");

%% divide by story

all_story_types = unique(all_data.story_type);
for i = 1:length(all_story_types)
    story = all_story_types(i);
    all_task_data = all_data(all_data.story_type == story, :);
    split_by_task{i} = all_task_data;
end

%%

base_db = "full_ingest_w_leftovers_may_2026!.mat";
types = ["approach_rate"; "norm_saccades"; "pupil_diameter"; "reaction_time"; "num_guesses"];
for j = 1:length(types)
    type = types(j);
    want_bdry = 1;
    want_scale = 1;
    type_data = rmoutliers(all_data.(type));
    scale_max = max(type_data);
    scale_min = min(type_data);
    want_save = 1;
    for_ml = 0;
    path_to_save = "C:\Users\lrako\OneDrive\Documents\human_dm\final_run_2026\hr_figs_may_2026\" ;
    mkdir(path_to_save)
    run_dec_making_plot_loop(split_by_task,all_story_types,path_to_save,want_bdry,want_scale,want_save,for_ml,base_db,type)
end

%% anova comparing tasks

task_cs = {};
base_db = "full_ingest_w_leftovers_may_2026!.mat";
all_story_types = unique(all_data.story_type);
types = ["approach_rate"; "norm_saccades"; "pupil_diameter"; "reaction_time"; "num_guesses"];
for j = 1:length(types)
    type = types(j);
    save_to = "C:\Users\lrako\OneDrive\Documents\human_dm\final_run_2026\all_subj_methods_anova\";
    mkdir(save_to)
    wanted_tasks = ["approach_avoid","social","probability","moral","nonsense","supersense"];
    c = comparison_btwn_tasks(split_by_task, all_story_types, wanted_tasks, type, save_to,base_db);
    task_cs{j} = c;
end

%% anova comparing rew levels 

rew_or_costs = ["rew";"cost"];
base_db = "full_ingest_w_leftovers_may_2026!.mat";
for r = 1:2
    rew_or_cost = rew_or_costs(r);
    types = ["approach_rate"; "norm_saccades"; "pupil_diameter"; "reaction_time"; "num_guesses"];
    for j = 1:length(types)
        type = types(j);
        save_to = "C:\Users\lrako\OneDrive\Documents\human_dm\final_run_2026\all_subj_methods_anova\";
        mkdir(save_to)
        wanted_tasks = ["approach_avoid","social","probability","moral","supersense","nonsense"];
        c = comparison_btwn_rew_lvls(split_by_task, all_story_types, wanted_tasks, type, rew_or_cost,save_to,base_db);
    end
end

%% anova comparing sexes

sex_counts = [];
base_db = "full_ingest_w_leftovers_may_2026!.mat";
types = ["approach_rate"; "norm_saccades"; "pupil_diameter"; "reaction_time"; "num_guesses"]; 
for j = 1:length(types)
    type = types(j);
    save_to = "C:\Users\lrako\OneDrive\Documents\human_dm\final_run_2026\all_subj_methods_sex_anova\";
    mkdir(save_to)
    [num_m, num_f] = comparison_btwn_sexes(split_by_task, ["approach_avoid"], ["approach_avoid"], type, save_to, base_db);
    sex_counts = [sex_counts; num_f num_m];
end


%% normalization bar plots

r_ratings = convert_story_types(r_ratings, "tasktype");
c_ratings = convert_story_types(c_ratings, "tasktype");

base_db = "full_ingest_w_leftovers_may_2026!.mat";
same_scale = 1;
save_to = "C:\Users\lrako\OneDrive\Documents\human_dm\final_run_2026\ratings\";
mkdir(save_to);
all_story_types = unique(r_ratings.tasktype);
for i = 1:length(all_story_types)
    type = all_story_types(i);
    get_ratings_by_subject(r_ratings,c_ratings,type,save_to,same_scale,base_db)
end
