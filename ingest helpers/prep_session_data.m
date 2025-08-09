function [N_trial_data, r_ratings, c_ratings] = prep_session_data(datasource, username, password, table_name)

[init_approach_data, r_ratings, c_ratings] = get_new_task(datasource,username,password,table_name);
[clean_approach_data, subject_prefs] = clean_ingested_new_task(init_approach_data,table_name);

% add new column for relevance
thresh = 0;
[pref_approach_data] = add_pref_column(clean_approach_data, subject_prefs, thresh);

% add new column for story type 
[approach_data] = add_story_column_loop(pref_approach_data);

% get data w enough trials 
min_num_sessions = 0;
[N_trial_data, idxs] = filter_hum_appr_data(approach_data, 16*min_num_sessions);

end