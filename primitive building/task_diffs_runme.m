%% calc prim table from prims_run_me

hum_table_name = "C:\Users\lrako\OneDrive\Documents\human dm\clustering\create clusters\og_cluster_dir_10-28-2024\all human data.xlsx";
main_hum = readtable(hum_table_name);

%% task diffs using primitives

type = "oct27";
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\task_prim_of_prims";
mkdir(save_to)
want_save = 1;
hum_or_rat = "human";
prim_histogram_by_task(prim_table,hum_or_rat, "mean appr" ,want_save,save_to);
prim_histogram_by_task(prim_table,hum_or_rat, "reward interact" ,want_save,save_to);
prim_histogram_by_task(prim_table,hum_or_rat, "cost interact" ,want_save,save_to);
prim_histogram_by_task(prim_table,hum_or_rat, "reward impulse" ,want_save,save_to);
prim_histogram_by_task(prim_table,hum_or_rat, "cost impulse" ,want_save,save_to);
prim_histogram_by_task(prim_table,hum_or_rat, "subj var" ,want_save,save_to);

%% cluster proportions

type = "oct27";
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\task_prim_of_prims";
story_types = ["approach_avoid", "moral","social","probability"];
plot_cluster_props_per_task(main_hum, story_types, save_to)