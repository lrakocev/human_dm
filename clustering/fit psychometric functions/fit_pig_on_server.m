
new_dir = "pig_on_server_2d/";
story_types = ["approach_avoid", "obvious_supersense", "social", "probability", "moral", "old_approach_avoid"];

sub_sub_dirs = ["cannon", "story_pref", "pupil_diam", "hunger", "tiredness", "pain",...
    "cannon_r", "story_pref_r", "pupil_diam_r", "hunger_r", "tiredness_r", "pain_r"];

for i = 1:length(story_types)
    sub_dir = new_dir + "/" + story_types(i);
    mk_new_dir_for_pig(sub_dir,sub_sub_dirs) 
    cd('../../')
end

%% get behavioral data

behavioral_data = "human_dm/for_dirk_updated.mat";
load(behavioral_data)

%% fit proposed models

home_dir = "pig_on_server_2d/";
story_types = ["approach_avoid", "obvious_supersense", "social", "probability", "moral", "old_approach_avoid"];

by_session = 1;
sig_type = "cost";
is_sigmoidal = 0;

thresh = 0;
create_sigmoids_by_subject(home_dir, story_types, session_data, by_session, sig_type, thresh, is_sigmoidal)

% can get AIC from the fitobject -- fitobject.ModelCriterion.AIC

%% if you want to check validity after (especially discreteness / clustering)

%{
num_clusters = 10;

colors = distinguishable_colors(num_clusters);
dir = "C:\Users\lrako\OneDrive\Documents\human dm\clustering\fit psychometric functions\pig_on_server\"; % wherever your home_dir was set to above 

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\clustering\fit psychometric functions\"; % wherever you want to save
mkdir(save_to)
file_name = "all_clusters";
directory_type = "\pupil*";
table_of_human_dir = get_dirs_with_data(dir, directory_type);
is_big = 0;
isolate_task = "";
[table_of_data, all_rs] = call_spectral_clustering_pig(table_of_human_dir,save_to,0,num_clusters,colors,'euclidean',is_big,file_name,isolate_task);
%}