%% calc prim table from prims_run_me

hum_table_name = "C:\Users\lrako\OneDrive\Documents\human dm\clustering\create clusters\og_cluster_dir_10-28-2024\all human data.xlsx";
main_hum = readtable(hum_table_name);

%% task diffs in cost aversion

stories = ["social","moral","approach_avoid"];
cost_aversion_by_task(prim_table, stories)

%% task diffs using primitives

type = "oct27";
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\task_prim_of_prims";
mkdir(save_to)
want_save = 1;
hum_or_rat = "human";
stories = ["probability","approach_avoid"];
prim_histogram_by_task(prim_table,hum_or_rat, "mean appr" , stories, want_save, save_to)
prim_histogram_by_task(prim_table,hum_or_rat, "reward interact" , stories, want_save, save_to)
prim_histogram_by_task(prim_table,hum_or_rat, "cost interact" , stories, want_save, save_to)
prim_histogram_by_task(prim_table,hum_or_rat, "reward impulse" , stories, want_save, save_to)
prim_histogram_by_task(prim_table,hum_or_rat, "cost impulse" , stories, want_save, save_to)
prim_histogram_by_task(prim_table,hum_or_rat, "subj var" , stories, want_save, save_to)

%% cluster proportions

type = "oct27";
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\task_prim_of_prims";
story_types = ["approach_avoid", "moral","social","probability"];
plot_cluster_props_per_task(main_hum, story_types, save_to)