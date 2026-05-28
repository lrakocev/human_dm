%% get starting tables

[merged_table, hr_table, eye_table] = get_physio_merged_tables();
%  prim_table = add_prims_to_table(merged_table);

%% feature types

hr_feats = ["min_hr", "max_hr", "mean_hr"];
eye_feats = ["num_saccads", "num_guesses", "reaction_time","pupil_diameter"];
hormone_feats = ["aGHR", "Estradiol_pg_mL_", "TotalTestos_ng_dL_"];
behavior_feats = ["r_impulse", "r_interact", "mean_appr"];

%% random groupings

num_bins = 5; 
bootstrap_bars(eye_table, num_bins, eye_feats)
bootstrap_bars(hr_table, num_bins, hr_feats)

%% comparing across naive groupings

want_z = 0;
num_bins = 5;
bin_by = "rawY";

% ["approach_rate", "rew", "cost", "reaction_time", "min_hr", "mean_hr", ...
% "max_hr", "num_guesses", "num_saccads", "pupil_diameter", "story_prefs", ...
% "hunger", "tiredness", "pain", "rawX", "rawY", "rawZ"]

feats_across_naive_binning(eye_table, bin_by, num_bins, eye_feats, want_z)
feats_across_naive_binning(hr_table, bin_by, num_bins, hr_feats, want_z)
feats_across_naive_binning(prim_table, bin_by, num_bins, hr_feats, want_z)

%% comparing across combination groupings

num_bins = 3;
want_z = 1;
bin_by = ["rawX","rawY","rawZ"];

combination_binning(eye_table, bin_by, num_bins, eye_feats, want_z)
combination_binning(hr_table, bin_by, num_bins, hr_feats, want_z)

%% sinai table

% load("C:\Users\lrako\OneDrive\Documents\human_dm\outside_data\mt_sinai_trial_table.mat")

curr_sheet = "avg_data"; % "win_money"
imt_table = readtable("C:\Users\lrako\OneDrive\Documents\human_dm_data\all_k_subject_imt_data.xlsx","Sheet",curr_sheet,"NumHeaderLines",0);

ghrelin_table = readtable(k01_home_folder + "/K01_tracking.xlsx","Sheet","ghrelin-updated","NumHeaderLines",0);
ghrelin_table.id = "K" + ghrelin_table.K01_SUBID;

mt_sinai_hormone_table = outerjoin(mt_sinai_cluster_table, ghrelin_table, "MergeKeys", 1, "Keys", {'id'});
mt_sinai_hormone_table = mt_sinai_hormone_table(~isnan(mt_sinai_hormone_table.x_coord), :);

%%

want_z = 1;
num_bins = 5;
%mt_sinai_hormone_table = renamevars(mt_sinai_hormone_table, "id", "subjectidnumber");
mt_sinai_hormone_table.log_x = log(abs(mt_sinai_hormone_table.x_coord));
mt_sinai_hormone_table.log_y = log(abs(mt_sinai_hormone_table.y_coord));
mt_sinai_hormone_table.log_z = log(abs(mt_sinai_hormone_table.z_coord));

sinai_bins = ["x_coord","y_coord","z_coord"];
%sinai_bins = ["log_x","log_y","log_z"];

%combination_binning(mt_sinai_hormone_table, sinai_bins, num_bins, hormone_feats, want_z)
bin_by = "x_coord";
feats_across_naive_binning(mt_sinai_hormone_table, bin_by, num_bins, hormone_feats, want_z)
