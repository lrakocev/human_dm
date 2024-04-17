%% ingest + format eye tables
cd('C:\Users\lrako\OneDrive\Documents\dec-making-app')
appr_avoid_eye = read_eye_csv_to_table("approach_avoid_eyetracking_0415.xlsx");
moral_eye = read_eye_csv_to_table("moral_eyetracking_0415.xlsx");
social_eye = read_eye_csv_to_table("social_eyetracking_0415.xlsx");
prob_eye = read_eye_csv_to_table("probability_eyetracking_0415.xlsx");

%% ingest + format hr tables

appr_avoid_hr = read_hr_csv_to_table("approach_avoid_hr_0415.xlsx");
social_hr = read_hr_csv_to_table("social_hr_0415.xlsx");
moral_hr = read_hr_csv_to_table("moral_hr_0415.xlsx");
prob_hr = read_hr_csv_to_table("probability_hr_0415.xlsx");

%% spectral table

table_name = "C:\Users\lrako\OneDrive\Documents\RECORD\all_human_data.xlsx";
spectral_table = readtable(table_name);

%% get behavioral data

% to get session data, need to run the hum_new_tasks_runme 

%% get psych data

want_plot = 0;
same_scale = 1;
save_to = "C:\Users\lrako\OneDrive\Documents\RECORD\summary stats + maps\final_run\avg_spec_cluster_psychs";
story_types = ["approach_avoid", "social", "probability", "moral"];
all_data{1} = appr_avoid_sessions;
all_data{2} = social_sessions;
all_data{3} = probability_sessions;
all_data{4} = moral_sessions;

all_psych_data = plot_avg_spec_cluster_psychs(spectral_table, all_data, same_scale, story_types, save_to, want_plot);
all_psych_data = renamevars(all_psych_data,'experiment','story_type');

%% merging tables

tot_eye = [appr_avoid_eye; social_eye; prob_eye; moral_eye];
tot_hr = [appr_avoid_hr; social_hr; prob_hr; moral_hr];
eye_merged = merge_feat_to_clusters(tot_eye, all_psych_data, 0);
hr_merged = merge_feat_to_clusters(tot_hr, all_psych_data, 1);

mega_merge = outerjoin(eye_merged,hr_merged,'MergeKeys',true,'Keys',...
    {'clusterX','clusterY','clusterZ','clusterLabels','story_type','idx',...
    'subjectidnumber','story_num','cost',...
    'nanmean_decision_made','nanmean_real_r'});

%% 3d plot 

num_clusters = max(all_psych_data.idx);
C = {[1 0 0], [0 1 0], [0 0 1],...
    [0 1 1], [1 0 1],[1 1 0],...
    [0 0 0],[0.8500 0.3250 0.0980],[0.4940 0.1840 0.5560]};
save_to = "C:\Users\lrako\OneDrive\Documents\RECORD\summary stats + maps\04_05_run\physio_corr\";
plot_physio_feats_3d(eye_merged,num_clusters,C,save_to,0)

plot_physio_feats_3d(hr_merged,num_clusters,C,save_to,1)
