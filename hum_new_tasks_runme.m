%% Human New Tasks Run Me

using_prefs = 0;
datasource = 'PostgreSQL30'; %ENTER YOUR DATASOURCE NAME HERE, default should be "live_database"
username = 'postgres'; %ENTER YOUR USERNAME HERE, default should be "postgres"
password = '1234'; %ENTER YOUR PASSWORD HERE, default should be "1234"

% ingest data
[init_approach_data, r_ratings, c_ratings] = get_new_task(datasource,username,password);
[clean_approach_data, subject_prefs] = clean_ingested_new_task(init_approach_data);

% add new column for relevance
thresh = 0;
if using_prefs
    thresh = 33;
end
[pref_approach_data] = add_pref_column(clean_approach_data, subject_prefs, thresh);

% add new column for story type 
[approach_data] = add_story_column_loop(pref_approach_data);

% get data w enough trials 
min_num_sessions = 2;
[N_trial_data, idxs] = filter_hum_appr_data(approach_data, 16*min_num_sessions);

% combine trials for dec maps
appr_avoid_combined_data = combine_for_map(N_trial_data, "approach_avoid");
social_combined_data = combine_for_map(N_trial_data, "social");
probability_combined_data = combine_for_map(N_trial_data, "probability");
moral_combined_data = combine_for_map(N_trial_data, "moral");

% separate each individual story out by type
appr_avoid_sessions = sessions_by_tasktype(N_trial_data, "approach_avoid");
social_sessions = sessions_by_tasktype(N_trial_data, "social");
probability_sessions = sessions_by_tasktype(N_trial_data, "probability");
moral_sessions = sessions_by_tasktype(N_trial_data, "moral");

% separate trials by story for dec map
appr_avoid_stories = combine_stories_for_map(N_trial_data, "approach_avoid");
social_stories = combine_stories_for_map(N_trial_data, "social");
probability_stories = combine_stories_for_map(N_trial_data, "probability");
moral_stories = combine_stories_for_map(N_trial_data, "moral");

%% get counts

num_tot_subjects = length(N_trial_data);
tot = [];
for i = 1:length(N_trial_data)
    tot = [tot; N_trial_data{1,i}];
end

num_all_subjects = length(unique(tot.subjectidnumber));

story_types = ["approach_avoid", "social", "probability", "moral"];
counts = [];
for j = 1:length(story_types)
    count = length(unique(tot(tot.story_type == story_types(j), :).subjectidnumber));
    counts = [counts; count];
end

aa_sessions = length(appr_avoid_sessions);
m_sessions = length(moral_sessions);
s_sessions = length(social_sessions);
p_sessions = length(probability_sessions);

total_sessions = aa_sessions + m_sessions + s_sessions + p_sessions;


%% normalization bar plots

same_scale = 1;
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session\ratings\";
story_types = ["approach_avoid", "social", "probability", "moral"];
for i = 1:4
    type = story_types(i);
    get_ratings_by_subject(r_ratings,c_ratings,type,save_to,same_scale)
end

%% dec making maps by story

want_bdry = 0;
want_scale = 0;
want_save = 1;
story_types = ["approach_avoid", "social", "probability", "moral"];
data{1} = appr_avoid_stories;
data{2} = social_stories;
data{3} = probability_stories;
data{4} = moral_stories;
path_to_save = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\dec_making_story_maps";

run_dec_making_plot_loop(data,story_types,path_to_save,want_bdry,want_scale,want_save)


%% dec making maps

want_bdry = 0;
want_scale = 0;
want_save = 1;
story_types = ["approach_avoid", "social", "probability", "moral"];
data{1} = appr_avoid_combined_data;
data{2} = social_combined_data;
data{3} = probability_combined_data;
data{4} = moral_combined_data;
path_to_save = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\dec_making_maps";

run_dec_making_plot_loop(data,story_types,path_to_save,want_bdry,want_scale,want_save)

%% avg map per task

story_types = ["approach_avoid", "social", "probability", "moral","all"];
data{1} = appr_avoid_combined_data;
data{2} = social_combined_data;
data{3} = probability_combined_data;
data{4} = moral_combined_data;
data{5} = [appr_avoid_combined_data;social_combined_data;probability_combined_data;moral_combined_data];
path_to_save = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\avg_maps";
want_bdry = 0;
want_scale = 1;
want_save = 1;

avg_data = make_avg_dec_making_plot(data, story_types, path_to_save,want_bdry,want_scale,want_save);

%% plotting summary stats

story_types = ["approach_avoid", "social", "probability", "moral"];
consts = ["reward", "cost"];
type = "approach rate";
data{1} = appr_avoid_combined_data;
data{2} = social_combined_data;
data{3} = probability_combined_data;
data{4} = moral_combined_data;

path_to_save = 'C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session\psych_stats\';

for s = 1:length(story_types)
    story_type = story_types(s);
    story_dir = path_to_save + story_type;
    mkdir(story_dir)
    combined_data = data{s};
    for c = 1:length(consts)
        constant = consts(c);
        story_type = story_types(s);

        % this plots all the individual results + the average - one plot per level
        avg_psychometric_plot_per_level(combined_data, type, constant, story_type, path_to_save)
        
        % this plots average results for each level - one plot total
        avg_psychometric_across_levels(combined_data,  type, constant, story_type, path_to_save)
        
        % this plots average result for reward vs cost - one plot per level
        avg_rew_v_cost_comparison_per_lvl(combined_data, type, constant, story_type, path_to_save)
        
        % this plots the 4 individual psychometric functions keeping constant r/c
        plot_individual_psychs_across_lvls(combined_data, constant, story_type, path_to_save)
    end
end