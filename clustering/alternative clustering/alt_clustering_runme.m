%% get behavioral data

% to get session data, need to run the hum_new_tasks_runme 

load("C:\Users\lrako\OneDrive\Documents\human_dm\final_hum_data_dec25.mat")


%% find session-cost sigmoids

input_data = session_data;
story_types = unique(r_ratings.tasktype);

sig_table = run_alt_fit(input_data,story_types, 0, 1);
sig_table.clusterLabels = sig_table.subjectidnumber + "_" + sig_table.story_num + ".mat";

%poly_table = run_alt_fit(input_data,story_types, 1, 0);
%poly_table.clusterLabels = poly_table.subjectidnumber + "_" + poly_table.story_num + ".mat";

%% using nnmf

story_types = unique(r_ratings.tasktype);
nnmf_table = run_alt_fit(session_data,story_types, 0, 0);
nnmf_table = struct2table(nnmf_table);
nnmf_table.clusterLabels = nnmf_table.subjectidnumber + "_" + nnmf_table.story_num + ".mat";
%%

hs = nnmf_table.h;
ws = nnmf_table.w;
figure
scatter3(hs(:,1), hs(:,2), hs(:,3))
title("hs 1 2 3")
xlabel("1")
ylabel("2")
zlabel("3")

figure
scatter3(hs(:,4), hs(:,2), hs(:,3))
title("hs 4 2 3")
xlabel("4")
ylabel("2")
zlabel("3")

figure
scatter3(ws(:,1), ws(:,2), ws(:,3))
title("ws 1 2 3")
xlabel("1")
ylabel("2")
zlabel("3")

figure
scatter3(ws(:,4), ws(:,2), ws(:,3))
title("ws 4 2 3")
xlabel("4")
ylabel("2")
zlabel("3")


%% clustering 2d sigs 

input_table = sig_table;
colors = distinguishable_colors(30);
save_to = "C:\Users\lrako\OneDrive\Documents\human_dm\dec_2025";
mkdir(save_to)
file_name = "2d_sig_clustering_subject_lvl_all_dec_2025";
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


