%% clusters runme using spectral clustering table

type = "all_session_updated";
table_name = "C:\Users\lrako\OneDrive\Documents\human dm\" + type + ".xlsx";
spectral_table = readtable(table_name);

%% get behavioral data

% to get session data, need to run the hum_new_tasks_runme 

%% concatenating the session tables into one big table per task

want_plot = 1;
same_scale = 1;
using_1d_sig = 0;
if using_1d_sig
    save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\avg_cluster_info";
else
    save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\2d sig clustering";
end    
mkdir(save_to)
use_cost = 0;
if contains(type,"cost")
    use_cost = 1;
end
story_types = ["all","approach_avoid", "social", "probability", "moral"];
all_data{1} = [appr_avoid_sessions moral_sessions social_sessions probability_sessions];
all_data{2} = appr_avoid_sessions;
all_data{3} = social_sessions;
all_data{4} = probability_sessions;
all_data{5} = moral_sessions;
split_by_dim = 0;
plot_interactions = 0;

all_psych_data = plot_avg_spec_cluster_psychs(spectral_table, all_data, same_scale, story_types, save_to, want_plot, split_by_dim, use_cost,plot_interactions);
all_psych_data = renamevars(all_psych_data,'experiment','story_type');

%% supplementary plot
plot_avg_task_cluster_psych(spectral_table, all_data, same_scale, story_types, save_to, use_cost)
