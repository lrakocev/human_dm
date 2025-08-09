%% clusters runme using spectral clustering table

% there's def a better version but this is what we've got
type = "all_clusters";
table_name = "C:\Users\lrako\OneDrive\Documents\human dm\july_2025\" + type + ".xlsx";
spectral_table = readtable(table_name);

%% get behavioral data

load("C:\Users\lrako\OneDrive\Documents\human dm\for_dirk.mat")

%% concatenating the session tables into one big table per task

want_plot = 1;
same_scale = 1;
using_1d_sig = 1;
if using_1d_sig
    save_to = "C:\Users\lrako\OneDrive\Documents\human dm\july_2025\avg_cluster_info";
else
    save_to = "C:\Users\lrako\OneDrive\Documents\human dm\july_2025\2d sig cluster_info";
end    
mkdir(save_to)
use_cost = 1;
if contains(type,"cost")
    use_cost = 1;
end
story_types = ["approach_avoid", "obvious_supersense", "social", "probability", "moral", "old_approach_avoid"];

plot_interactions = 0;

all_psych_data = plot_avg_spec_cluster_psychs(spectral_table, session_data, same_scale, story_types, save_to, want_plot, use_cost,plot_interactions);
