%% create new directory for data

new_dir = 'C:\Users\lrako\OneDrive\Documents\human_dm\test_run\dec_2025';
mkdir(new_dir)
story_types = unique(r_ratings.tasktype);
for i = 1:length(story_types)
    sub_dir = new_dir + "/" + story_types(i);
    mk_new_dir_for_clusters(sub_dir) 
    cd('../../')
end

%% get behavioral data

load("C:\Users\lrako\OneDrive\Documents\human dm\hum_data_oct25.mat")

%% find session-cost sigmoids

home_dir = "C:\Users\lrako\OneDrive\Documents\human_dm\test_run\dec_2025\";
story_types = unique(r_ratings.tasktype);
by_session = 0;
sig_type = "cost"; 

thresh = 0.7;
is_sigmoidal = 1;
create_sigmoids(home_dir, story_types, session_data, by_session, sig_type, thresh, is_sigmoidal);

%% find session sigmoids

home_dir = "C:\Users\lrako\OneDrive\Documents\human_dm\test_run\subject_lvl_oct2025\";
story_types = ["approach_avoid","obvious_supersense", "social", "probability", "moral", "old_approach_avoid"]; 

input_data = combined_data;
by_session = 1;
sig_type = "cost";
is_sigmoidal = 1;
thresh = 0.4;
total_fit = create_sigmoids(home_dir, story_types, input_data, by_session, sig_type, thresh, is_sigmoidal);

%% get % sigmoidal vs non sigmoidal

% prev_dir = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\session_clustering\";
new_starting_dir = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\session_reward_clustering\";
story_types = ["approach_avoid","social","moral","probability","super"];
save_to ="C:\Users\lrako\OneDrive\Documents\human dm\test_run\psych_stats\sessions_reward_clustering";
mkdir(save_to)
fin_summary = sigmoidal_percentage(new_starting_dir, story_types, save_to);
