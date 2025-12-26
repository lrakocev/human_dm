
all_story_types = ["approach_avoid", "obvious_supersense", "social", "probability", "moral", "old_approach_avoid"];

for i = 1:length(all_story_types)
    story = all_story_types(i);
    task_session_data = sessions_by_tasktype(all_trial_data, story);
    session_data{i} = task_session_data;
end


%% for maps for each task type

all_story_types =  unique(r_ratings.tasktype);
for i = 1:length(all_story_types)
    story = all_story_types(i);
    task_combined_data = combine_for_map(all_trial_data_w_story, story);
    combined_data{i} = task_combined_data;
end

%%

all_story_types = unique(r_ratings.tasktype);
for i = 1:length(all_story_types)
    story = all_story_types(i);
    story_session_data = combine_stories_for_map(all_trial_data_w_story, story);
    story_data{i} = story_session_data;
end

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

%% normalization bar plots

same_scale = 1;
save_to = "C:\Users\lrako\OneDrive\Documents\human_dm\final_run_2026\ratings\";
mkdir(save_to);
all_story_types = unique(r_ratings.tasktype);
for i = 1:length(all_story_types)
    type = all_story_types(i);
    get_ratings_by_subject(r_ratings,c_ratings,type,save_to,same_scale)
end

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

run_dec_making_plot_loop(combined_data,all_story_types,path_to_save,want_bdry,want_scale,want_save,for_ml,type)

%% avg map per task

type = "approach_rate";
want_bdry = 1;
want_scale = 0;
want_save = 1;
for_ml = 0;
all_story_types = unique(r_ratings.tasktype);
path_to_save = "C:\Users\lrako\OneDrive\Documents\human_dm\final_run_2026\dec_making_maps\" + type;
mkdir(path_to_save)

run_dec_making_plot_loop(combined_data,all_story_types,path_to_save,want_bdry,want_scale,want_save,for_ml,type)

%% plotting summary stats

all_story_types = ["approach_avoid", "obvious_supersense", "social", "probability", "moral", "old_approach_avoid"];
consts = ["reward", "cost"];
type = "approach rate";

path_to_save = 'C:\Users\lrako\OneDrive\Documents\human dm\july_2025\';

for s = 1:length(all_story_types)
    story_type = all_story_types(s);
    story_dir = path_to_save + story_type;
    mkdir(story_dir)
    task_combined_data = combined_data{s};
    for c = 1:length(consts)
        constant = consts(c);
        story_type = all_story_types(s);

        % this plots all the individual results + the average - one plot per level
        avg_psychometric_plot_per_level(task_combined_data, type, constant, story_type, path_to_save)
        
        % this plots average results for each level - one plot total
        avg_psychometric_across_levels(task_combined_data,  type, constant, story_type, path_to_save,1)
        
        % this plots average result for reward vs cost - one plot per level
        avg_rew_v_cost_comparison_per_lvl(task_combined_data, type, constant, story_type, path_to_save)
        
        % this plots the 4 individual psychometric functions keeping constant r/c
        plot_individual_psychs_across_lvls(task_combined_data, constant, story_type, path_to_save)
    end
end

%% overlapped for fig 3

all_story_types = unique(r_ratings.tasktype);
story_idx = find(contains(all_story_types,["approach_avoid","positive","negative"]));
consts = ["reward", "cost"];
type = "approach rate";

path_to_save = 'C:\Users\lrako\OneDrive\Documents\human_dm\final_run_2026\psych_stats\';
colors = distinguishable_colors(length(all_story_types));
actual_story_types = [];
for c = 1:length(consts)
    constant = consts(c);
    figure
    hs = [];
    task_anova = [];
    ls = [];
    lvls = [];
    for idx = 1:length(story_idx)
        s = story_idx(idx);
        story_type = all_story_types(s);
        story_dir = path_to_save + story_type;
        mkdir(story_dir)
        task_combined_data = combined_data{s};
    
        story_type = all_story_types(s);

        actual_story_types = [actual_story_types; story_type];
        % this plots all the individual results + the average - one plot per level
        color = colors(s,:);
        [h,avg,lvl_lens] = avg_psychometric_across_levels(task_combined_data,  type, constant, story_type, color, path_to_save, 0);
        avg = reshape(avg,1,4*length(avg));
        task_anova = [task_anova avg];
        ls = [ls; length(avg)];
        hs = [hs; h];
        hold on

        for j = 1:length(lvl_lens)
            lvl_len = lvl_lens(j);
            lvls = [lvls repelem(j, lvl_len)];
        end
    end

    tasks = [];
    for l = 1:length(ls)
        len = ls(l);
        tasks = [tasks repelem(l, len)];
    end

    %{
    [p,t,stats,terms] =  anovan(task_anova, {tasks;lvls},'model','interaction','varnames',{'task','lvl'});
    title("comparison of avg approach rates for tasks, with constant " + constant + ", two-way anova btwn tasks: p=" + string(p));
    %}
    legend(hs,actual_story_types)
    hold off
    set(gcf,'renderer','Painters')
    saveas(gcf,strcat(path_to_save,'/overlapped_avg_psych_constant',constant,'_across_lvls'),'fig')
    saveas(gcf,strcat(path_to_save,'/overlapped_avg_psych_constant',constant,'_across_lvls'),'svg')
end