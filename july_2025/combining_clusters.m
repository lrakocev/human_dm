%% get full table of behavioral data 

all_data = [];
for j = 1:length(all_trial_data)
    all_data = [all_data; all_trial_data{j}];
end

%% 1d clusters

type = "human_clusters";
table_name = "C:\Users\lrako\OneDrive\Documents\human dm\july_2025\" + type + ".xlsx";
clusters_1d = readtable(table_name);

clusters_1d = psychs_in_spec_cluster(clusters_1d,1);

%% 2d clusters

type = "2d_clustering_0810";
table_name = "C:\Users\lrako\OneDrive\Documents\human dm\july_2025\" + type + ".xlsx";
clusters_2d = readtable(table_name);

clusters_2d = psychs_in_spec_cluster(clusters_2d, 0);

%% autoencoder clusters ... maybe not

%TODO: get the coordinates from the autoencoder (labeled by coordinate)

%% join 1d+2d in one table

cluster_merged = outerjoin(clusters_2d,clusters_1d,'Keys',{'experiment','story_num','subjectidnumber'},'MergeKeys',1);
all_data = renamevars(all_data, "story_type", "experiment");

behavior_merged = outerjoin(cluster_merged,all_data,'Keys',{'experiment','story_num','subjectidnumber'},'MergeKeys',1);
behavior_merged = renamevars(behavior_merged, "cost_all_data","cost");

%% correlations btwn groupings

want_plot = 0;
all_corrs = eng_corr_by_cluster_combo(behavior_merged, want_plot);

%% clusters vs parameters

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\july_2025\cluster_params";
mkdir(save_to)
measure_cluster_table = parameters_per_cluster(behavior_merged);

plot_per_cluster_params(measure_cluster_table,save_to)

%% appr rate vs parameters

k=3;
appr_lvl_table = parameters_per_appr_lvl(all_data, k);

plot_per_appr_lvl_params(appr_lvl_table)

%% parameters vs appr rate entropy

measures = ["pupil_diameter", "heart_rate", "pain", "hunger", "tiredness", "story_prefs", "cost", "rew"];

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\july_2025\task_entropy_v_params";
num_bins = 12;
prsqs = [];
for i = 1:length(measures)
    measure = measures(i);
    appr_entropy_table = parameters_per_appr_entropy(all_data,num_bins,measure);

    [prsq] = predict_appr_entropy(appr_entropy_table,measure,[]);
    set(gcf,'renderer','Painters')
    saveas(gcf,save_to + "/" + measure + "_v_entropy_all_tasks","fig")
    saveas(gcf,save_to + "/" + measure + "_v_entropy_all_tasks","svg")
    close all 
    prsqs = [prsqs; prsq];
end

%% parameters vs appr rate per cluster entropy 

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\july_2025\cluster_entropy_v_params";
mkdir(save_to)
num_bins = 12;
r_table = param_v_appr_entropy_per_cluster(behavior_merged,num_bins,save_to);

%% parameters vs appr rate per task entropy 

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\july_2025\task_entropy_v_params";
mkdir(save_to)
num_bins = 12;
param_v_appr_entropy_per_task(all_data,num_bins,save_to)