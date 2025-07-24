
new_dir = "pig_on_server/";
story_types = ["approach_avoid", "obvious_supersense", "social", "probability", "moral", "old_approach_avoid"];
for i = 1:length(story_types)
    sub_dir = new_dir + "/" + story_types(i);
    mk_new_dir_for_pig(sub_dir) 
    cd('../../')
end

%% get behavioral data

behavioral_data = "scratch/lrakocevic/human_dm/for_dirk.mat";
load(behavioral_data)

%% fit proposed models

home_dir = "pig_on_server/";
story_types = ["approach_avoid", "obvious_supersense", "social", "probability", "moral", "old_approach_avoid"];

by_session = 0;
sig_type = "cost";
is_sigmoidal = 0;

thresh = 0;
create_sigmoids(home_dir, story_types, session_data, by_session, sig_type, thresh, is_sigmoidal)

%% if you want to check validity after (especially discreteness / clustering)

num_clusters = 15;

colors = distinguishable_colors(num_clusters);
dir = "pig_on_server/"; % wherever your home_dir was set to above 

save_to = 'C:\Users\lrako\OneDrive\Documents\human dm\july_2025';
mkdir(save_to)
file_name = "all_clusters";
table_of_human_dir = get_dirs_with_data(dir);
is_big = 0;
isolate_task = "";
table_of_data = call_spectral_clustering_combine_all_human_data(table_of_human_dir,save_to,0,num_clusters,colors,'euclidean',is_big,file_name,isolate_task);
