%% 2D clustering human

num_clusters = 5;
colors = distinguishable_colors(num_clusters);
file_name = 'human_2d_clusters';
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\2d_clustering";
spectral_clustering_2D(human_table, num_clusters, 'euclidean', colors, save_to, file_name,"human")

%% 2D clustering rat

num_clusters = 6;
colors = distinguishable_colors(num_clusters);
file_name = 'rat_2d_clusters';
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\2d_clustering";
spectral_clustering_2D(rat_table, num_clusters, 'euclidean', colors, save_to, file_name,"rat")

%% rat-human distance comparison 

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\2d_clustering";
human_data = readtable(save_to + "/human_2d_clusters.xlsx");
rat_data = readtable(save_to + "/rat_2d_clusters.xlsx");
version_name = "hum v rat 2d comparison";
get_bhat_dist_heat_map_comparing_rat_to_human_2d(human_data,rat_data,1, ...
    save_to,version_name,1,1)

colors = distinguishable_colors(11);
normalized_human_to_rat_comparison_single_plot_2d(rat_data, ...
    human_data,save_to,"2d cluster plot rat to human comparison",colors,1)

%% RUN THE ABOVE OR JUST LOAD THIS CELL:

human_data = readtable("C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\2d_clustering\human_2d_clusters.xlsx");
rat_data = readtable("C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\2d_clustering\rat_2d_clusters.xlsx");


%% 2D hum prim table

load("C:\Users\lrako\OneDrive\Documents\human dm\ingest helpers\human data.mat")
all_data{1} = [appr_avoid_sessions moral_sessions social_sessions probability_sessions];
story_types = ["all"];
use_cost = 0;
human_data.clusterLabels = human_data.clusterLabels + " " + human_data.experiment;
hum_2d_prim = get_prim_data(human_data, all_data, story_types, use_cost);

%% 2D rat prim table

raw_rat_psychometric_function_data = readtable("C:\Users\lrako\OneDrive\Documents\human dm\baseline reward_choice psychometric functions table.xlsx");
rat_2d_prim = get_rat_prim_data(rat_data, raw_rat_psychometric_function_data);

%% rat prims histograms

want_save = 1;
hum_or_rat = "rat";
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\2d_clustering";
rat_r_impulse_means = prim_histogram(rat_2d_prim,hum_or_rat, "reward impulse", want_save, save_to);
rat_raw_val_means = prim_histogram(rat_2d_prim, hum_or_rat, "raw valuation", want_save, save_to);
rat_raw_elast_means = prim_histogram(rat_2d_prim,hum_or_rat, "raw elasticity", want_save, save_to);
prim_histogram(rat_2d_prim,hum_or_rat, "sesh var", want_save, save_to);
prim_histogram(rat_2d_prim,hum_or_rat, "reward interact", want_save, save_to);

%% hum prims histograms

want_save = 1;
hum_or_rat = "human";
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\2d_clustering";
r_impulse_means = prim_histogram(hum_2d_prim, hum_or_rat, "reward impulse",want_save,save_to);
raw_val_means = prim_histogram(hum_2d_prim, hum_or_rat,"raw valuation",want_save,save_to);
raw_elast_means = prim_histogram(hum_2d_prim,hum_or_rat, "raw elasticity",want_save,save_to);
prim_histogram(hum_2d_prim,hum_or_rat, "sesh var", want_save, save_to);
prim_histogram(hum_2d_prim,hum_or_rat, "reward interact", want_save, save_to);

%% 2d homology

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\2d_clustering";
version_name = "hum v rat 2d comparison";
want_save = 1;
want_and = 1;
dist_2d_table = rat_hum_distance_2d(human_data,rat_data,1, save_to,version_name,1);

thresh = 0.25;
viz = rat_to_hum_homolog(rat_2d_prim, hum_2d_prim ,dist_2d_table,want_save,save_to,want_and,thresh);

%%  OR use the 2d plot for distance but use the 3d clustering ?? 

viz = rat_to_hum_homolog(new_rat_prim_table, prim_table ,dist_2d_table, want_save,save_to,want_and,10);

