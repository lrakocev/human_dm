function [pref_approach_data, r_ratings, c_ratings] = prep_session_data(datasource, username, password, table_name, trial_word_length_table)

if contains(table_name,"utep")
    query = "select subjectidnumber,tasktypedone,story_prefs,reward_prefs,cost_prefs,reward_level,cost_level,decision_made,trial_start,trial_end,hunger,tired,pain,sex,age,trial_elapsed,pupil_diameter,raw_heart_rate,left_gaze_coords from " + table_name + ""; 
else
    query = "select subjectidnumber,tasktypedone,story_prefs,reward_prefs,cost_prefs,reward_level,cost_level,decision_made,trial_start,trial_end,hungry,tired,in_pain,gender,age_range,trial_elapsed from " + table_name + ""; 
end

conn = database(datasource,username,password); %creates the database connection

%pool = gcp;
%c = createConnectionForPool(pool,datasource,username,password);
splitSize = 2000;
querybasket = splitsqlquery(conn,query,'SplitSize',splitSize);

clean_approach_data = [];
subject_prefs = [];
r_ratings = [];
c_ratings = [];
for i = 1:length(querybasket)
    %conn = c.Value;
    [init_approach_data, curr_r_ratings, curr_c_ratings]  = get_new_task(querybasket(i), conn, table_name);
    [curr_approach_data, curr_prefs] = clean_ingested_new_task(init_approach_data,table_name,trial_word_length_table);
    clean_approach_data = [clean_approach_data curr_approach_data];
    subject_prefs = [subject_prefs curr_prefs];
    r_ratings = [r_ratings; curr_r_ratings];
    c_ratings = [c_ratings; curr_c_ratings];
end


% add new column for relevance
thresh = 0;
[pref_approach_data] = add_pref_column(clean_approach_data, subject_prefs, thresh);

%{
% add new column for story type 
[approach_data] = add_story_column_loop(pref_approach_data);

% get data w enough trials 
min_num_sessions = 0;
[N_trial_data, idxs] = filter_hum_appr_data(approach_data, 16*min_num_sessions);
%}

end