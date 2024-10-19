%% get behavioral data

% to get session data, need to run the hum_new_tasks_runme 

load("C:\Users\lrako\OneDrive\Documents\human dm\ingest helpers\human data.mat")

%% find session-cost sigmoids

story_types = ["approach_avoid", "social", "probability", "moral"];
data{1} = appr_avoid_sessions;
data{2} = social_sessions;
data{3} = probability_sessions;
data{4} = moral_sessions;

%poly_table = run_alt_fit(data,story_types, 1);
sig_table = run_alt_fit(data,story_types, 0);

%poly_table.clusterLabels = poly_table.subjectidnumber + "_" + poly_table.story_num + ".mat";
sig_table.clusterLabels = sig_table.subjectidnumber + "_" + sig_table.story_num + ".mat";

%% clustering 2d sigs 

colors = distinguishable_colors(30);
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\2d sig clustering";
mkdir(save_to)
file_name = "density_v2";
feats = ["a_R","b_R","b_C"];
spectral_clustering_2D_sig(sig_table, feats, colors, save_to, file_name)

%% dec making plot per "cluster"

want_plot = 1;
same_scale = 1;
use_cost = 0;
using_1d_sig = 0;
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\2d sig clustering";

story_types = ["all","approach_avoid", "social", "probability", "moral"];
all_data{1} = [appr_avoid_sessions moral_sessions social_sessions probability_sessions];
all_data{2} = appr_avoid_sessions;
all_data{3} = social_sessions;
all_data{4} = probability_sessions;
all_data{5} = moral_sessions;
split_by_dim = 0;
plot_interactions = 0;

table_name = "density_v1.xlsx";
input_table = readtable("C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\2d sig clustering\" + table_name);
all_psych_data = plot_avg_spec_cluster_psychs(input_table, all_data, same_scale, story_types, save_to, want_plot, split_by_dim, use_cost,plot_interactions);


