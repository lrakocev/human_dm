
type = "all_session_updated";
table_name = "C:\Users\lrako\OneDrive\Documents\human dm\" + type + ".xlsx";
spectral_table = readtable(table_name);

%% get behavioral data

load("C:\Users\lrako\OneDrive\Documents\human dm\ingest helpers\human data.mat")

%% get psych data 

want_plot = 0;
same_scale = 1;
plot_interactions = 0;
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

all_psych_data = plot_avg_spec_cluster_psychs(spectral_table, all_data, same_scale, story_types, save_to, want_plot, use_cost, plot_interactions);

%% subjects in cluster

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\subjects_in_cluster\";
mkdir(save_to)
story_types =  ["approach_avoid", "social", "probability", "moral", "all"];
y_max = 0.7; 
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

%% line plots of individual subject strategies

home_dir = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\subjects_in_cluster\lines_overlaid\";
story_types = ["approach_avoid", "social", "moral", "probability"];
for s = 1:length(story_types)
    story_type = story_types(s);
    save_to = home_dir;
    mkdir(save_to)
    indiv_line_plots_overlaid(all_psych_data, story_type, save_to)
end
