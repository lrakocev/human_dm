%% get behavioral data

% to get session data, need to run the hum_new_tasks_runme 

%% get spectral all_psych_data
want_plot = 0;
same_scale = 1;
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\avg_cluster_info";
story_types = ["approach_avoid", "social", "probability", "moral"];
all_data{1} = appr_avoid_sessions;
all_data{2} = social_sessions;
all_data{3} = probability_sessions;
all_data{4} = moral_sessions;

all_psych_data = plot_avg_spec_cluster_psychs(spectral_table, all_data, same_scale, story_types, save_to, want_plot);
all_psych_data = renamevars(all_psych_data,'experiment','story_type');

%% calcs + plotting (run_chain takes a while)

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\chaining\";
tasks = ["approach_avoid","social","moral","probability"];
sample_size = 500;
total_table = run_chain(tasks,sample_size);
summary_table = create_summary_table(all_psych_data,total_table,tasks);
plot_heatmap(summary_table,save_to)