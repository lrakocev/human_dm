%% Human New Tasks Run Me

datasource = 'PostgreSQL30'; %ENTER YOUR DATASOURCE NAME HERE, default should be "live_database"
username = 'postgres'; %ENTER YOUR USERNAME HERE, default should be "postgres"
password = '1234'; %ENTER YOUR PASSWORD HERE, default should be "1234"

% ingest data
[init_approach_data, r_ratings, c_ratings] = get_new_task(datasource,username,password);
approach_data = clean_ingested_new_task(init_approach_data);

%add new column for story type 
[approach_data] = add_story_column_loop(approach_data);

% get data w enough trials 
min_num_sessions = 2;
[N_trial_data, idxs] = filter_hum_appr_data(approach_data, 16*min_num_sessions);

% combine trials for dec maps
appr_avoid_combined_data = combine_for_map(N_trial_data, "approach_avoid");
social_combined_data = combine_for_map(N_trial_data, "social");
probability_combined_data = combine_for_map(N_trial_data, "probability");
moral_combined_data = combine_for_map(N_trial_data, "moral");

% separate each individual story out by type
appr_avoid_sessions = sessions_by_tasktype(N_trial_data, "approach_avoid");
social_sessions = sessions_by_tasktype(N_trial_data, "social");
probability_sessions = sessions_by_tasktype(N_trial_data, "probability");
moral_sessions = sessions_by_tasktype(N_trial_data, "moral");


%% normalization bar plots

same_scale = 1;
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\ratings\";
story_types = ["approach_avoid", "social", "probability", "moral"];
for i = 1:4
    type = story_types(i);
    get_ratings_by_subject(r_ratings,c_ratings,type,save_to,same_scale)
end

%% dec making maps

want_bdry = 0;
want_scale = 0;
want_save = 1;
story_types = ["approach_avoid", "social", "probability", "moral"];
data{1} = appr_avoid_combined_data;
data{2} = social_combined_data;
data{3} = probability_combined_data;
data{4} = moral_combined_data;
path_to_save = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\dec_making_maps";
for i = 1:4
    combined_data = data{i};
    story_type = story_types{i};
    for N = 1:length(combined_data)
        curr_data = combined_data{N};
        if ~isempty(curr_data)
            make_dec_making_plots(curr_data, path_to_save, story_type,want_bdry,want_scale,want_save)
        end
    end
end

%% avg map per task

story_types = ["approach_avoid", "social", "probability", "moral","all"];
data{1} = appr_avoid_combined_data;
data{2} = social_combined_data;
data{3} = probability_combined_data;
data{4} = moral_combined_data;
data{5} = [appr_avoid_combined_data;social_combined_data;probability_combined_data;moral_combined_data];
path_to_save = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\avg_maps";
want_bdry = 0;
want_scale = 1;
want_save = 1;

avg_data = cell(1,4);

for i = 1:length(story_types)
    combined_data = data{i};
    story_type = story_types{i};
    tot_table = [];
    for N = 1:length(combined_data)
        curr_data = combined_data{N};
        if ~isempty(curr_data)
            tot_table = [tot_table; curr_data];
        end
    end
    avg_table = [];
    for r = 1:4
        for c = 1:4
            all_r_c = tot_table(tot_table.rew == r & tot_table.cost == c, :);
            r_c_row = all_r_c(1,:);
            r_c_row.subjectidnumber = "scaled avg";
            r_c_row.approach_rate = mean(all_r_c.approach_rate, 'omitnan');
            avg_table = [avg_table; r_c_row];
        end
    end
    avg_data{i} = avg_table;
    make_dec_making_plots(avg_table, path_to_save, story_type,want_bdry,want_scale,want_save)
end

%% plotting summary stats

story_types = ["approach_avoid", "social", "probability", "moral"];
consts = ["reward", "cost"];
type = "approach rate";
data{1} = appr_avoid_combined_data;
data{2} = social_combined_data;
data{3} = probability_combined_data;
data{4} = moral_combined_data;

path_to_save = 'C:\Users\lrako\OneDrive\Documents\human dm\test_run\psych_stats\';

for s = 1:length(story_types)
    story_type = story_types(s);
    combined_data = data{s};
    for c = 1:length(consts)
        constant = consts(c);
        story_type = story_types(s);

        % this plots all the individual results + the average - one plot per level
        avg_psychometric_plot_per_level(combined_data, type, constant, story_type, path_to_save)
        
        % this plots average results for each level - one plot total
        avg_psychometric_across_levels(combined_data,  type, constant, story_type, path_to_save)
        
        % this plots average result for reward vs cost - one plot per level
        avg_rew_v_cost_comparison_per_lvl(combined_data, type, constant, story_type, path_to_save)
        
        % this plots the 4 individual psychometric functions keeping constant r/c
        plot_individual_psychs_across_lvls(combined_data, constant, story_type, path_to_save)
    end
end