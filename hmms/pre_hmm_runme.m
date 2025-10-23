%% pre-hmm-run

% need to split the autoencoder sessions into clusters to create
% "cluster_combo"

[filtered_behavior_table, prim_table] = prep_data_for_hmm(home_dir,base_file_name);

adj_filtered_table = add_category(filtered_behavior_table, "story_categories.xlsx");

good_story_table = adj_filtered_table(adj_filtered_table.story_category ~= "bad", :);
bad_story_table = adj_filtered_table(adj_filtered_table.story_category == "bad", :);

% save these two tables 