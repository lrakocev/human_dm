dir = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\min_pref_session_clustering\";
table_of_human_dir = get_dirs_with_data(dir);
colors = distinguishable_colors(10);
call_spectral_clustering_combine_all_human_data(table_of_human_dir,"doesnt matter",0,8,colors,'euclidean')