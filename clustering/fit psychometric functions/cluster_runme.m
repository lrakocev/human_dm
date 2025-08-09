%% create new directory for data

new_dir = 'C:\Users\lrako\OneDrive\Documents\human dm\test_run\no_filter_full_07';
mkdir(new_dir)
story_types = ["old_approach_avoid", "super", "approach_avoid", "social", "probability", "moral"];
for i = 1:length(story_types)
    sub_dir = new_dir + "/" + story_types(i);
    mk_new_dir_for_clusters(sub_dir) 
    cd('../../')
end

%% get behavioral data

load("C:\Users\lrako\OneDrive\Documents\human dm\ingest helpers\human data.mat")

%% find session-cost sigmoids

home_dir = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\no_filter_full_07\";
story_types = ["approach_avoid", "social", "probability", "moral", "super"]; %, "old_approach_avoid"];
data{1} = appr_avoid_sessions;
data{2} = social_sessions;
data{3} = probability_sessions;
data{4} = moral_sessions;
data{5} = super_sessions;

by_session = 0;
sig_type = "reward"; %% sigh - this should be "cost" for cost-lvl psychs, need to re-run

thresh = 0;
is_sigmoidal = 1;
create_sigmoids(home_dir, story_types, data, by_session, sig_type, thresh, is_sigmoidal);

%% find session sigmoids

home_dir = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\sessions_oct_27\";
story_types = ["approach_avoid", "social", "probability", "moral"];
data{1} = appr_avoid_sessions;
data{2} = social_sessions;
data{3} = probability_sessions;
data{4} = moral_sessions;
by_session = 1;
sig_type = "cost";
thresh = 0.4;
total_fit = create_sigmoids(home_dir, story_types, data, by_session, sig_type, thresh);

%% get % sigmoidal vs non sigmoidal

% prev_dir = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\session_clustering\";
new_starting_dir = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\session_reward_clustering\";
story_types = ["approach_avoid","social","moral","probability","super"];
save_to ="C:\Users\lrako\OneDrive\Documents\human dm\test_run\psych_stats\sessions_reward_clustering";
mkdir(save_to)
fin_summary = sigmoidal_percentage(new_starting_dir, story_types, save_to);
