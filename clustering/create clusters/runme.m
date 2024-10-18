%% human
num_clusters = 16;

colors = distinguishable_colors(num_clusters);
dir = 'C:\Users\lrako\OneDrive\Documents\human dm\test_run\session_clustering';
save_to = 'C:\Users\lrako\OneDrive\Documents\human dm\primitive building';
file_name = "human_clusters";
table_of_human_dir = get_dirs_with_data(dir);
is_big = 0;
call_spectral_clustering_combine_all_human_data(table_of_human_dir,save_to,0,num_clusters,colors,'euclidean',is_big,file_name)

%%  rat
dir = 'C:\Users\lrako\OneDrive\Documents\human dm\rat sigmoid data';
save_to = 'C:\Users\lrako\OneDrive\Documents\human dm\primitive building';

%{
table_of_rat_dir.Task = "rat";
table_of_rat_dir.Data_Directory = dir;
table_of_rat_dir = struct2table(table_of_rat_dir);
%}

num_clusters = 15;

colors = distinguishable_colors(num_clusters);
is_big = 0;

file_name = "rat_clusters_num_clusters_" + string(num_clusters);
call_spectral_clustering_combine_all_human_data(table_of_rat_dir,save_to,0,num_clusters,colors,'euclidean',is_big,file_name)

