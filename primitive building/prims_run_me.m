%% human cluster data - created using C:\Users\lrako\OneDrive\Documents\human dm\clustering\create clusters\run_me.m

% just using this to get the raw coefficient values
raw = "human_clusters";
raw_name = "C:\Users\lrako\OneDrive\Documents\human dm\primitive building\" + raw + ".xlsx";
spectral_table = readtable(raw_name);

% main human data
type = "all_session_updated";
main_hum = readtable("C:\Users\lrako\OneDrive\Documents\human dm\" + type + ".xlsx");
merged = outerjoin(spectral_table, main_hum, "Keys", {'experiment','clusterLabels'},"MergeKeys", 1);
merged.cluster_number_spectral_table = [];
merged.clusterX_spectral_table = [];
merged.clusterY_spectral_table = [];
merged.clusterZ_spectral_table = [];
main_hum_table = renamevars(merged, {'clusterX_main_hum','clusterY_main_hum',...
    'clusterZ_main_hum','cluster_number_main_hum'},...
    {'clusterX','clusterY','clusterZ','cluster_number'});


%% get behavioral data

% to get session data, need to run the hum_new_tasks_runme 
load("C:\Users\lrako\OneDrive\Documents\human dm\ingest helpers\human data.mat")

%% concatenating the session tables into one big table per task

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\prim_of_prims";
mkdir(save_to)
use_cost = 0;
if contains(type,"cost")
    use_cost = 1;
end
story_types = ["all"]; %"approach_avoid"
all_data{1} = [appr_avoid_sessions moral_sessions social_sessions probability_sessions];

main_hum_table.clusterLabels = main_hum_table.clusterLabels + " " + main_hum_table.experiment;

prim_table = get_prim_data(main_hum_table, all_data, story_types, use_cost);

plot_interactions = 0;
all_psych_data = plot_avg_spec_cluster_psychs(main_hum_table, all_data, 0, "all", save_to, 0, use_cost, plot_interactions);

%% prim histogram

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\prim_of_prims_stats";
want_save = 1;
hum_or_rat = "human";
alt_mse_means = prim_histogram(prim_table,hum_or_rat, "indiv var from cluster mean" ,want_save,save_to);
subj_var_means = prim_histogram(prim_table,hum_or_rat, "subj var",want_save,save_to);
r_interact_means = prim_histogram(prim_table,hum_or_rat, "reward interact",want_save,save_to);
c_interact_means = prim_histogram(prim_table,hum_or_rat, "cost interact",want_save,save_to);
r_impulse_means = prim_histogram(prim_table, hum_or_rat, "reward impulse",want_save,save_to);
c_impulse_means = prim_histogram(prim_table,hum_or_rat, "cost impulse",want_save,save_to);
mean_appr_means = prim_histogram(prim_table,hum_or_rat, "mean appr",want_save,save_to);
max_appr_means = prim_histogram(prim_table,hum_or_rat, "max appr",want_save,save_to);
min_appr_means = prim_histogram(prim_table,hum_or_rat, "min appr",want_save,save_to);
raw_val_means = prim_histogram(prim_table, hum_or_rat,"raw valuation",want_save,save_to);
raw_elast_means = prim_histogram(prim_table,hum_or_rat, "raw elasticity",want_save,save_to);

%% cluster variance plots

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\prim_of_prims_stats\cluster_var";
mkdir(save_to)
want_save = 1;
plot_cluster_variance(prim_table, save_to, want_save)