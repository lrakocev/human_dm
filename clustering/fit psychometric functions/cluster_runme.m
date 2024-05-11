%% create new directory for data

new_dir = 'C:\Users\lrako\OneDrive\Documents\human dm\test_run\session_reward_clustering';
mkdir(new_dir)
story_types = ["approach_avoid", "social", "probability", "moral"];
for i = 1:length(story_types)
    sub_dir = new_dir + "/" + story_types(i);
    mk_new_dir_for_clusters(sub_dir) 
    cd('../../')
end

%% get behavioral data

% to get session data, need to run the hum_new_tasks_runme 

%% find session-cost sigmoids

home_dir = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\session_reward_clustering\";
story_types = ["approach_avoid", "social", "probability", "moral"];
data{1} = appr_avoid_sessions;
data{2} = social_sessions;
data{3} = probability_sessions;
data{4} = moral_sessions;
by_session = 0;
sig_type = "reward";

create_sigmoids(home_dir, story_types, data, by_session, sig_type)

%% find session sigmoids

home_dir = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\min_pref_session_clustering\";
story_types = ["approach_avoid", "social", "probability", "moral"];
data{1} = appr_avoid_sessions;
data{2} = social_sessions;
data{3} = probability_sessions;
data{4} = moral_sessions;
by_session = 1;
sig_type = "cost";

create_sigmoids(home_dir, story_types, data, by_session, sig_type)

%% get % sigmoidal vs non sigmoidal

new_starting_dir = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\session_cost_clustering\";
story_types = ["approach_avoid","social","moral","probability"];
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\psych_cost_session_counts";

fin_summary = sigmoidal_percentage(new_starting_dir, story_types, save_to)

%% probability of behavior -- this is outdated, leaving it in temporarily

home_dir = "C:\Users\lrako\OneDrive\Documents\RECORD\Stopping Points\human_dec_making\final_run\sessions\";
sigmoid_type = "sessions";
num_clusters = 4;
means_2d = prep_means();
probability_of_behavior(home_dir, sigmoid_type, num_clusters, means_2d)
