%% clusters runme using spectral clustering table

type = "all_clusters_with_sign";
table_name = "C:\Users\lrako\OneDrive\Documents\human_dm\dec_2025\" + type + ".xlsx";
spectral_table = readtable(table_name);

%% get behavioral data

load("C:\Users\lrako\OneDrive\Documents\human_dm\final_hum_data_dec25.mat")

%% concatenating the session tables into one big table per task

want_plot = 1;
same_scale = 1;
using_1d_sig = 1;
if using_1d_sig
    save_to = "C:\Users\lrako\OneDrive\Documents\human_dm\dec_2025\" + type;
else
    save_to = "C:\Users\lrako\OneDrive\Documents\human_dm\dec_2025\2d_sig_clustering";
end    
mkdir(save_to)
use_cost = 1;
story_types = ["all"];% unique(r_ratings.tasktype);
plot_interactions = 0;

all_psych_data = plot_avg_spec_cluster_psychs(spectral_table, session_data, same_scale, story_types, save_to, want_plot, use_cost,plot_interactions);

%% supplementary plot
plot_avg_task_cluster_psych(spectral_table, all_data, same_scale, story_types, save_to, use_cost)
