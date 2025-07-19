%% human
num_clusters = 15;

colors = distinguishable_colors(num_clusters);
dir = 'C:\Users\lrako\OneDrive\Documents\human dm\test_run\no_filter_full_07';
save_to = 'C:\Users\lrako\OneDrive\Documents\human dm\july_2025';
mkdir(save_to)
file_name = "all_clusters";
table_of_human_dir = get_dirs_with_data(dir);
is_big = 0;
isolate_task = "";
table_of_data = call_spectral_clustering_combine_all_human_data(table_of_human_dir,save_to,0,num_clusters,colors,'euclidean',is_big,file_name,isolate_task)

%%  rat
dir = 'C:\Users\lrako\OneDrive\Documents\human dm\rat sigmoid data';
save_to = 'C:\Users\lrako\OneDrive\Documents\human dm\primitive building';
num_clusters = 6;

colors = distinguishable_colors(num_clusters);
is_big = 0;

file_name = "rat_clusters_num_clusters_" + string(num_clusters);
call_spectral_clustering_combine_all_human_data(table_of_rat_dir,save_to,0,num_clusters,colors,'euclidean',is_big,file_name)

