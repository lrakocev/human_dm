%% clusters runme using spectral clustering table

type = "min_pref_session_cost";
table_name = "C:\Users\lrako\OneDrive\Documents\human dm\" + type + ".xlsx";
spectral_table = readtable(table_name);

%% get behavioral data

% to get session data, need to run the hum_new_tasks_runme 

%% concatenating the session tables into one big table per task

want_plot = 1;
same_scale = 1;
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\avg_cluster_info";
mkdir(save_to)
use_cost = 0;
if contains(type,"cost")
    use_cost = 1;
end
story_types = ["approach_avoid", "social", "probability", "moral", "all"];
all_data{1} = appr_avoid_sessions;
all_data{2} = social_sessions;
all_data{3} = probability_sessions;
all_data{4} = moral_sessions;
all_data{5} = [appr_avoid_sessions moral_sessions social_sessions probability_sessions];
split_by_dim = 0;

all_psych_data = plot_avg_spec_cluster_psychs(spectral_table, all_data, same_scale, story_types, save_to, want_plot, split_by_dim, use_cost);
all_psych_data = renamevars(all_psych_data,'experiment','story_type');