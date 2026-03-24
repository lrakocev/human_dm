function [merged_table, hr_table, eye_table] = get_physio_merged_tables()

title = "original";
want_sign = 0;
type = "all_clusters_original";
table_name = "C:\Users\lrako\OneDrive\Documents\human_dm\dec_2025\" + type + ".xlsx";
spectral_table = readtable(table_name);

%  get behavioral data - this is where all_data table comes from (all trials)

load("C:\Users\lrako\OneDrive\Documents\human_dm\final_hum_data_dec25.mat")

[all_data_w_story] = add_story_column_loop({all_data});
all_data_w_story = all_data_w_story{1};


all_story_types = unique(r_ratings.tasktype);
for i = 1:length(all_story_types)
    story = all_story_types(i);
    task_session_data = sessions_by_tasktype({all_data_w_story}, story);
    session_data{i} = task_session_data;
end

% get psych table

want_plot = 0;
same_scale = 0;
using_1d_sig = 1;
save_to = "";   
use_cost = 1;
story_types = ["all"];
plot_interactions = 0;

all_psych_data = plot_avg_spec_cluster_psychs(spectral_table, session_data, same_scale, story_types, save_to, want_plot, use_cost,plot_interactions);
all_psych_data = renamevars(all_psych_data, "experiment", "story_type");

% merged physio tables

merged_table = outerjoin(all_psych_data, all_data_w_story, 'MergeKeys',1,'Keys',{'subjectidnumber','story_type','story_num','cost'});
merged_table.max_hr = merged_table.max_hr * 100;
merged_table.min_hr = merged_table.min_hr * 100;

hr_table = merged_table(~isnan(merged_table.mean_hr), :);
eye_table = merged_table(~isnan(merged_table.pupil_diameter), :);

end
