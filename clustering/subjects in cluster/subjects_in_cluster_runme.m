
type = "all_session";
table_name = "C:\Users\lrako\OneDrive\Documents\human dm\" + type + ".xlsx";
spectral_table = readtable(table_name);

%% get behavioral data

% to get session data, need to run the hum_new_tasks_runme 

%% get psych data 

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

%% subjects in cluster

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\subjects_in_cluster\";
mkdir(save_to)
story_types =  ["approach_avoid", "social", "probability", "moral"];
y_max = 0.5; 
for s = 1:length(story_types)
    story_type = story_types(s);
    subjects_in_cluster_3d(all_psych_data, story_type, y_max, save_to)
end

%% individual subjects strategies across clusters

home_dir = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\subjects_in_cluster\individual\";
story_types = ["approach_avoid", "social", "moral", "probability"];
for s = 1:length(story_types)
    story_type = story_types(s);
    save_to = home_dir + story_type + "\";
    mkdir(save_to)
    indiv_subjects_in_cluster_3d(all_psych_data, story_type, save_to)
end
