%% human data ingest

datasource = 'PostgresJDBC'; %ENTER YOUR DATASOURCE NAME HERE, default should be "live_database" or "PostgreSQL30"
username = 'postgres'; %ENTER YOUR USERNAME HERE, default should be "postgres"
password = '1234'; %ENTER YOUR PASSWORD HERE, default should be "1234"

%trial_word_length = create_trial_length_table("C:\Users\lrako\OneDrive\Documents\human_dm\ingest helpers\stories\task_types");

cd("C:\Users\lrako\OneDrive\Documents\human_dm\ingest helpers")
[new_trial_data, r_ratings, c_ratings] = prep_session_data(datasource, username, password, "human_dec_making_table_utep", trial_word_length);
[old_trial_data, ~, ~] = prep_session_data(datasource, username, password, "human_dec_making_table", trial_word_length);

all_trial_data = [new_trial_data old_trial_data];

all_data = [];
for i = 1:length(new_trial_data)
    all_data = [all_data; new_trial_data{i}];
end
