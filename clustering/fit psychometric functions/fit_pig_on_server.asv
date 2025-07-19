
new_dir = pwd;

story_types = ["old_approach_avoid", "super", "approach_avoid", "social", "probability", "moral"];
for i = 1:length(story_types)
    sub_dir = new_dir + "/" + story_types(i);
    mk_new_dir_for_clusters(sub_dir) 
    cd('../../')
end

%% get behavioral data

behavioral_data = pwd + "/no_filter_full_07_11";
load(beharioal_data)

%% fit proposed models

home_dir = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\no_filter_full_07\";
story_types = ["approach_avoid", "social", "probability", "moral", "super"]; %, "old_approach_avoid"];
data{1} = appr_avoid_sessions;
data{2} = social_sessions;
data{3} = probability_sessions;
data{4} = moral_sessions;
data{5} = super_sessions;

by_session = 0;
sig_type = "reward";

thresh = 0;
create_sigmoids(home_dir, story_types, data, by_session, sig_type, thresh)