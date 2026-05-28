%% first run human_data_ingest.m or load("final_hum_data_dec25.mat")

%% get counts

num_tot_subjects = length(N_trial_data);
tot = [];
for i = 1:length(N_trial_data)
    tot = [tot; N_trial_data{1,i}];
end

num_all_subjects = length(unique(tot.subjectidnumber));

all_story_types = ["approach_avoid", "social", "probability", "moral"];
counts = [];
all_ids = [];
for j = 1:length(all_story_types)
    ids = unique(tot(tot.story_type == all_story_types(j), :).subjectidnumber);
    all_ids = [all_ids; ids];
    count = length(ids);
    counts = [counts; count];
end

aa_sessions = length(appr_avoid_sessions);
m_sessions = length(moral_sessions);
s_sessions = length(social_sessions);
p_sessions = length(probability_sessions);

total_sessions = aa_sessions + m_sessions + s_sessions + p_sessions;

%% metadata counts

results = get_hum_metadata();
single_table = consolidate_metadata(results, all_ids);

sex = groupcounts(single_table,'sex');
age = groupcounts(single_table,'age');
race = groupcounts(single_table,'race');
ethnicity = groupcounts(single_table,'ethnicity'); 

%% dec making maps by story

want_bdry = 1;
want_scale = 0;
want_save = 1;
for_ml = 0;
all_story_types = unique(r_ratings.tasktype);

path_to_save = "C:\Users\lrako\OneDrive\Documents\human_dm\final_run_2026\dec_making_story_maps";
mkdir(path_to_save)
run_dec_making_plot_loop(story_data,all_story_types,path_to_save,want_bdry,want_scale,want_save,for_ml)


%% dec making maps

want_bdry = 1;
want_scale = 0;
want_save = 1;
for_ml = 0;
all_story_types = unique(r_ratings.tasktype);
type = "approach_rate";
path_to_save = "C:\Users\lrako\OneDrive\Documents\human_dm\final_run_2026\dec_making_maps\" + type;
mkdir(path_to_save)

run_dec_making_plot_loop(combined_for_indiv_map_data,all_story_types,path_to_save,want_bdry,want_scale,want_save,for_ml,"indiv_examples",type)

%% avg map per task

type = "pupil_diameter";
want_bdry = 1;
want_scale = 0;
want_save = 1;
for_ml = 0;
all_story_types = unique(r_ratings.tasktype);
path_to_save = "C:\Users\lrako\OneDrive\Documents\human_dm\final_run_2026\dec_making_maps\" + type;
mkdir(path_to_save)

run_dec_making_plot_loop(split_by_task,all_story_types,path_to_save,want_bdry,want_scale,want_save,for_ml,type)

%% plotting summary stats

all_story_types = unique(r_ratings.tasktype);
consts = ["cost"];%, "cost"];
type = "approach rate";

path_to_save = 'C:\Users\lrako\OneDrive\Documents\human_dm\ex_for_raquel\';

for s = 1:length(all_story_types)
    story_type = all_story_types(s);
    story_dir = path_to_save + story_type;
    mkdir(story_dir)
    
   % avg_task = avg_task_combined{s};
    all_task = combined_for_indiv_map_data{s};
    for c = 1:length(consts)
        constant = consts(c);
        story_type = all_story_types(s);

        % this plots all the individual results + the average - one plot per level
       % avg_psychometric_plot_per_level(all_task, type, constant, story_type, path_to_save)
        
        % this plots average results for each level - one plot total
        % avg_psychometric_across_levels(all_task,  type, constant, story_type,[1, 0, 0], path_to_save,1)
        
        % this plots average result for reward vs cost - one plot per level
        % avg_rew_v_cost_comparison_per_lvl(all_task, type, constant, story_type, path_to_save)
        
        % this plots the 4 individual psychometric functions keeping constant r/c
         plot_individual_psychs_across_lvls(task_combined_data, constant, story_type, path_to_save)
    end
end

%% overlapped for fig 

type = "approach_rate";
save_to = "C:\Users\lrako\OneDrive\Documents\human_dm\final_run_2026\dec_making_maps";
wanted_tasks = ["approach_avoid","social","probability","moral"];
c = comparison_btwn_tasks(split_by_task, r_ratings, wanted_tasks, type, save_to);
