%% human data ingest

try 
    load("C:\Users\lrako\OneDrive\Documents\human_dm\ingest helpers\hum_data_may_2026.mat")
    new_trial_data_w_eye = new_trial_data;

    load("C:\Users\lrako\OneDrive\Documents\human_dm\for_dirk_updated.mat")
    [new_trial_data_w_story] = add_story_column_loop(new_trial_data);
    [old_trial_data_w_story] = add_story_column_loop(old_trial_data);

    all_trial_data = [old_trial_data_w_story new_trial_data_w_story new_trial_data_w_eye];
catch
end
    
%%
    datasource = 'PostgresJDBC'; %ENTER YOUR DATASOURCE NAME HERE, default should be "live_database" or "PostgreSQL30"
    username = 'postgres'; %ENTER YOUR USERNAME HERE, default should be "postgres"
    password = '1234'; %ENTER YOUR PASSWORD HERE, default should be "1234"
    
   trial_word_length = create_trial_length_table("C:\Users\lrako\OneDrive\Documents\human_dm\ingest helpers\stories\task_types");
    
    cd("C:\Users\lrako\OneDrive\Documents\human_dm\ingest helpers")

    [new_trial_data, r_ratings, c_ratings, failed_to_clean, all_not_processed, prev_save_for_later, raw_data]  = prep_session_data(datasource, username, password, "human_dec_making_table_utep", trial_word_length);
  
    %%
    [old_trial_data, ~, ~] = prep_session_data(datasource, username, password, "human_dec_making_table", trial_word_length);
    
    all_trial_data = [new_trial_data old_trial_data];

    % dealing with the incomplete sessions
    table_name = "human_dec_making_table_utep";
    incomplete_session_results = process_left_over_ingested_data(prev_save_for_later, table_name);
    trial_word_length = create_trial_length_table("C:\Users\lrako\OneDrive\Documents\human_dm\ingest helpers\stories\task_types");
    [incomplete_session_appr_data,~] = clean_ingested_new_task(incomplete_session_results,table_name,trial_word_length);
    [incomplete_session_appr_data_w_story] = add_story_column_loop(incomplete_session_appr_data);

%% putting it all into a single table

all_initial_data = [];
for i = 1:length(new_trial_data)
    if ~isempty(new_trial_data{i})
        try
            all_initial_data = [all_initial_data; new_trial_data{i}];
        catch
            continue
        end
    end
end

all_initial_data = unique(all_initial_data, "rows");

%% breaking into sessions

all_story_types = unique(r_ratings.tasktype);
for i = 1:length(all_story_types)
    story = all_story_types(i);
    task_session_data = sessions_by_tasktype({all_data}, story);
    session_data{i} = task_session_data;
end

%% 

all_story_types = unique(r_ratings.tasktype);
for i = 1:length(all_story_types)
    story = all_story_types(i);
    all_task_data = all_data_w_story(all_data_w_story.story_type == story, :);
    split_by_task{i} = all_task_data;
end


%% 

for j = 1:length(split_by_task)
    task_data = split_by_task{j};
    filtered_data = task_data((task_data.reaction_time ~= 0 & task_data.num_guesses ~= 0 & ...
        task_data.num_saccads ~= 0), :); 
    physio_split_by_task{j} = filtered_data;

end

%%
% for maps for each task type

all_story_types =  unique(r_ratings.tasktype);
for i = 1:length(all_story_types)
    story = all_story_types(i);
    task_combined_data = combine_for_map(N_trial_data, story);
    combined_for_indiv_map_data{i} = task_combined_data;
end

% for maps per story

all_story_types = unique(r_ratings.tasktype);
for i = 1:length(all_story_types)
    story = all_story_types(i);
    story_session_data = combine_stories_for_map(N_trial_data, story);
    story_data{i} = story_session_data;
end

all_story_types = unique(r_ratings.tasktype);
for i = 1:length(all_story_types)
    story = all_story_types(i);
    all_task_data = all_data_w_story(all_data_w_story.story_type == story, :);
    split_by_task{i} = all_task_data;
end


for j = 1:length(split_by_task)
    task_data = split_by_task{j};
    filtered_data = task_data((task_data.reaction_time ~= 0 & task_data.num_guesses ~= 0 & ...
        task_data.num_saccads ~= 0), :); 
    physio_split_by_task{j} = filtered_data;

end

%% avg task combined

all_story_types = unique(r_ratings.tasktype);
for i = 1:length(all_story_types)
    story = all_story_types(i);
    task_combined_data = combine_for_map({all_data_w_story}, story);
    avg_task_combined{i} = task_combined_data;
end
