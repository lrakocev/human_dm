%% rat cluster data - created using C:\Users\lrako\OneDrive\Documents\human dm\clustering\create clusters\run_me.m

rat_file = "rat_clusters";
rat_name = "C:\Users\lrako\OneDrive\Documents\human dm\primitive building\" + rat_file + ".xlsx";
rat_table = readtable(rat_name);

old_rat = readtable("C:\Users\lrako\OneDrive\Documents\human dm\rat_reward_choice.xlsx");
merged = outerjoin(rat_table, old_rat, "Keys", 'clusterLabels',"MergeKeys", 1);
merged.cluster_number_rat_table = [];
merged.clusterX_rat_table = [];
merged.clusterY_rat_table = [];
merged.clusterZ_rat_table = [];
old_rat_table = renamevars(merged, {'clusterX_old_rat','clusterY_old_rat',...
    'clusterZ_old_rat','cluster_number_old_rat'},...
    {'clusterX','clusterY','clusterZ','cluster_number'});

%% rat behavioral data

raw_rat_psychometric_function_data = readtable("C:\Users\lrako\OneDrive\Documents\human dm\baseline reward_choice psychometric functions table.xlsx");

%% get prims

% new rat
new_rat_prim_table = get_rat_prim_data(rat_table, raw_rat_psychometric_function_data);

% old rat
old_rat_prim_table = get_rat_prim_data(old_rat_table, raw_rat_psychometric_function_data);


%% prim viz

want_old = 0;
if want_old
    rat_prim_table = old_rat_prim_table;
else
    rat_prim_table = new_rat_prim_table;
end
%%
want_save = 0;
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\prim_of_prims_overcluster";
mkdir(save_to)
hum_or_rat = "rat";

rat_prim_table = rat_2d_prim;
rat_r_impulse_means = prim_histogram(rat_prim_table,hum_or_rat, "reward impulse", want_save, save_to);
rat_raw_val_means = prim_histogram(rat_prim_table, hum_or_rat, "raw valuation", want_save, save_to);
rat_raw_elast_means = prim_histogram(rat_prim_table,hum_or_rat, "raw elasticity", want_save, save_to);
rat_mean_appr_means = prim_histogram(rat_prim_table,hum_or_rat, "mean appr", want_save, save_to);
rat_mse_means = prim_histogram(rat_prim_table,hum_or_rat, "mse", want_save, save_to);
