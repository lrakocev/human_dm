%% clusters runme using spectral clustering table

type = "all_session_cost";
table_name = "C:\Users\lrako\OneDrive\Documents\human dm\" + type + ".xlsx";
spectral_table = readtable(table_name);

%% get behavioral data

% to get session data, need to run the hum_new_tasks_runme 

%% concatenating the session tables into one big table per task

want_plot = 0;
same_scale = 1;
split_by_dim = 0;
save_to = "";
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

all_psych_data = plot_avg_spec_cluster_psychs(spectral_table, all_data, same_scale, story_types, save_to, want_plot, split_by_dim, use_cost);
all_psych_data = renamevars(all_psych_data,'experiment','story_type');

%%
story_types = ["approach_avoid", "social", "probability", "moral"];
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\probability_of_behavior";
mkdir(save_to)
for i = 1:length(story_types)
    story = story_types(i);
     probability_of_behavior_3d(all_psych_data, story, save_to)
end