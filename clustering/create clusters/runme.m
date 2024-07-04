dir = 'C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\simulated\';
%table_of_human_dir = get_dirs_with_data(dir);
table_of_human_dir.Task = "all";
table_of_human_dir.Data_Directory = dir;

colors = distinguishable_colors(10);
call_spectral_clustering_combine_all_human_data(table_of_human_dir,"cluster",0,5,colors,'euclidean')