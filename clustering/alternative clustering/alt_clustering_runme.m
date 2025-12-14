%% get behavioral data

% to get session data, need to run the hum_new_tasks_runme 

load("C:\Users\lrako\OneDrive\Documents\human_dm\new_human_data_nov25.mat")


%% get subject-task level data

story_types = ["approach_avoid", "obvious_supersense", "social", "probability", "moral", "old_approach_avoid"];

for i = 1:length(story_types)
    story = story_types(i);
    task_combined_data = combine_for_map(all_trial_data, story);
    combined_data{i} = task_combined_data;
end


%% find session-cost sigmoids

input_data = combined_data;
story_types = ["approach_avoid", "obvious_supersense", "social", "probability", "moral", "old_approach_avoid"];

sig_table = run_alt_fit(input_data,story_types, 0);
sig_table.clusterLabels = sig_table.subjectidnumber + "_" + sig_table.story_num + ".mat";

poly_table = run_alt_fit(input_data,story_types, 1);
poly_table.clusterLabels = poly_table.subjectidnumber + "_" + poly_table.story_num + ".mat";

%% clustering 2d sigs 

input_table = sig_table;
colors = distinguishable_colors(30);
save_to = "C:\Users\lrako\OneDrive\Documents\human_dm\october_2025";
mkdir(save_to)
file_name = "2d_sig_clustering_subject_lvl_all_data_oct25";
feats = ["a_R","b_R","b_C"];
type = "2d sig"; 
%{
centers = [0.5 0.2 -116;
    -1.5 -.9 -70;
    0.5 -0.9 -0.9;
    89.6 50 0;
    77 19.5 -2.4;
    155 42 -2.3];
%}
centers = [];
num_clusters = 5; % size(centers,2);

spectral_clustering_2D_sig(input_table, feats, colors, centers, num_clusters, save_to, file_name, type)

%% dec making plot per "cluster"

want_plot = 1;
same_scale = 1;
use_cost = 0;
using_1d_sig = 0;
type = "all_session_updated";
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\2d sig fcm clustering";
mkdir(save_to)
story_types = ["all","approach_avoid", "social", "probability", "moral"];
all_data{1} = [appr_avoid_sessions moral_sessions social_sessions probability_sessions];
all_data{2} = appr_avoid_sessions;
all_data{3} = social_sessions;
all_data{4} = probability_sessions;
all_data{5} = moral_sessions;
split_by_dim = 0;
plot_interactions = 0;

table_name = "fcm_clusters.xlsx";
input_table = readtable("C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\2d sig clustering\" + table_name);
all_psych_data = plot_avg_spec_cluster_psychs(input_table, all_data, same_scale, story_types, save_to, want_plot, use_cost,plot_interactions);


