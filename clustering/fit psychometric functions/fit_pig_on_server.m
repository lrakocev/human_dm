
new_dir = "pig_on_server/";
story_types = ["super", "approach_avoid", "social", "probability", "moral"];
for i = 1:length(story_types)
    sub_dir = new_dir + "/" + story_types(i);
    mk_new_dir_for_pig(sub_dir) 
    cd('../../')
end

%% get behavioral data

behavioral_data = "scratch/lrakocevic/human_dm/test_run/no_filter_full_07_11.mat";
load(behavioral_data)

%% fit proposed models

home_dir = pwd + "\" + new_dir;
story_types = ["approach_avoid", "social", "probability", "moral", "super"];
data{1} = appr_avoid_sessions;
data{2} = social_sessions;
data{3} = probability_sessions;
data{4} = moral_sessions;
data{5} = super_sessions;

by_session = 0;
sig_type = "cost";
is_sigmoidal = 0;

thresh = 0;
create_sigmoids(home_dir, story_types, data, by_session, sig_type, thresh, is_sigmoidal)