%% get starting tables

[merged_table, hr_table, eye_table] = get_physio_merged_tables();

%% bar plots of physio features
hr_feats = ["min_hr", "max_hr", "mean_hr"];
save_to = "C:\Users\lrako\OneDrive\Documents\human_dm\dec_2025\physio_with_sign\";
mkdir(save_to)

plot_physio_feats_bar_plot(hr_table, hr_feats, save_to)

eye_feats = ["num_saccads", "num_guesses", "reaction_time","pupil_diameter"];
plot_physio_feats_bar_plot(eye_table, eye_feats, save_to)

%% mt sinai conversion to same cluster labels

load("C:\Users\lrako\OneDrive\Documents\human_dm\outside_data\mt_sinai_trial_table.mat")
new_mt_sinai_cluster_table = cluster_sinai_w_utep(spectral_table, mt_sinai_trial_table, want_sign);

hormone_table_name = "C:\Users\lrako\OneDrive\Documents\human_dm_data\K01_tracking.xlsx";
ghrelin_table = readtable(hormone_table_name,"Sheet","ghrelin-updated","NumHeaderLines",0);
ghrelin_table.id = "K" + ghrelin_table.K01_SUBID;

mt_sinai_hormone_table = outerjoin(new_mt_sinai_cluster_table, ghrelin_table, "MergeKeys", 1, "Keys", {'id'});
mt_sinai_hormone_table = mt_sinai_hormone_table(~isnan(mt_sinai_hormone_table.x_coord), :);

%% spider plots with all physio/hormonal features

hr_feats = ["min_hr", "max_hr", "mean_hr"];
eye_feats = ["num_saccads", "num_guesses", "reaction_time","pupil_diameter"];
hormone_feats = ["aGHR", "Estradiol_pg_mL_", "TotalTestos_ng_dL_"];
plot_physio_spider_plot(merged_table, mt_sinai_hormone_table, eye_feats, hr_feats, hormone_feats, title)

