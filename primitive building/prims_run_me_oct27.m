%% SAME THING BUT USING CLUSTERS CREATED OCT 27/28

hum_table_name = "C:\Users\lrako\OneDrive\Documents\human dm\clustering\create clusters\og_cluster_dir_10-28-2024\all human data.xlsx";
main_hum = readtable(hum_table_name);

%% get behavioral data

% to get session data, need to run the hum_new_tasks_runme 
load("C:\Users\lrako\OneDrive\Documents\human dm\ingest helpers\human data.mat")

%% concatenating the session tables into one big table per task

type = "oct27";
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\prim_of_prims";
mkdir(save_to)
use_cost = 0;
if contains(type,"cost")
    use_cost = 1;
end
story_types = ["all"]; %"approach_avoid"
all_data{1} = [appr_avoid_sessions moral_sessions social_sessions probability_sessions];

main_hum.clusterLabels = main_hum.clusterLabels + " " + main_hum.experiment;
prim_table = get_prim_data(main_hum, all_data, story_types, use_cost);
save(save_to, "prim_table")

plot_interactions = 1;
all_psych_data = plot_avg_spec_cluster_psychs(main_hum, all_data, 0, "all", save_to, 0, use_cost, plot_interactions);

%% prim histogram

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\prim_of_prims_stats";
mkdir(save_to)
want_save = 1;
hum_or_rat = "human";
prim_histogram(prim_table,hum_or_rat, "sesh var",want_save,save_to);
prim_histogram(prim_table,hum_or_rat, "subj var",want_save,save_to);

alt_mse_means = prim_histogram(prim_table,hum_or_rat, "indiv var from cluster mean" ,want_save,save_to);
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

%% subject variance plots
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\prim_of_prims_stats\sub_var";
mkdir(save_to)
want_save = 1;
plot_subj_variance(prim_table, save_to, want_save)