%% clusters runme using spectral clustering table

type = "all_session";
table_name = "C:\Users\lrako\OneDrive\Documents\human dm\" + type + ".xlsx";
spectral_table = readtable(table_name);

%% get behavioral data

% to get session data, need to run the hum_new_tasks_runme 

%% get spectral all_psych_data
want_plot = 0;
same_scale = 1;
save_to = "";
use_cost = 0;
if contains(type,"cost")
    use_cost = 1;
end
split_by_dim = 0;
story_types = ["approach_avoid", "social", "probability", "moral"];
all_data{1} = appr_avoid_sessions;
all_data{2} = social_sessions;
all_data{3} = probability_sessions;
all_data{4} = moral_sessions;

all_psych_data = plot_avg_spec_cluster_psychs(spectral_table, all_data, same_scale, story_types, save_to, want_plot, split_by_dim, use_cost);
all_psych_data = renamevars(all_psych_data,'experiment','story_type');

%% calcs + plotting (run_chain takes a while)

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type +  "\chaining\";
mkdir(save_to)
tasks = ["approach_avoid","social","moral","probability"];
use_cost = 0;
sample_size = 150;
if contains(type,"cost")
    use_cost = 1;
    sample_size = 500;
end
total_table = run_chain(all_psych_data,tasks,sample_size,save_to,type);
total_table = renamevars(total_table,"t1","task1");
total_table = renamevars(total_table,"t2","task2");
summary_table = create_summary_table(all_psych_data,total_table,tasks);
plot_heatmap(summary_table,save_to)

%% validation plot

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type +  "\chaining\";
total_table_name = save_to + '/total_table_' + type + '.mat';
load(total_table_name)
total_table = renamevars(total_table,"t1","task1");
total_table = renamevars(total_table,"t2","task2");
tasks = ["approach_avoid","social","moral","probability"];
summary_table = create_summary_table(all_psych_data,total_table,tasks);
plot_chain_validation(summary_table,all_psych_data,10,"desc",save_to);

plot_chain_validation(summary_table,all_psych_data,1,"asc",save_to);

