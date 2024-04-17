%% create new directory for data

new_name = 'social';
mk_new_dir_for_clusters(new_name)

%% get behavioral data

% to get session data, need to run the hum_new_tasks_runme 

%% find session sigmoids

home_dir = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\clustering\";
story_types = ["approach_avoid", "social", "probability", "moral"];
data{1} = appr_avoid_sessions;
data{2} = social_sessions;
data{3} = probability_sessions;
data{4} = moral_sessions;

create_sigmoids(home_dir, story_types, data)

%% get % sigmoidal vs non sigmoidal

starting_dir = "C:\Users\lrako\OneDrive\Documents\RECORD\summary stats + maps\04_05_run\clusters\sessions\";
story_types = ["approach_avoid","social","moral","probability"];

fin_summary = sigmoidal_percentage(starting_dir, story_types);

%% probability of behavior -- this is outdated, leaving it in temporarily

home_dir = "C:\Users\lrako\OneDrive\Documents\RECORD\Stopping Points\human_dec_making\final_run\sessions\";
sigmoid_type = "sessions";
num_clusters = 4;
means_2d = prep_means();
probability_of_behavior(home_dir, sigmoid_type, num_clusters, means_2d)
