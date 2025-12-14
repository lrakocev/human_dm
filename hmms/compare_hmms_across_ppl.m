%% compare hmms across people 

init_table = "hum_data_oct25.mat"; 

% for trial feats data is nov25 - new_human_data_nov25.mat
% for trial data is oct 25 - hum_data_oct25.mat
load(init_table)

id_data = group_by_feature(all_data, "subjectidnumber");

filtered_behavior_table = prep_data_for_hmm("",init_table,0);


%% get hmm tables

state_options = 2:7;
base_dir = "C:\Users\lrako\OneDrive\Documents\server_output\trials";
hmm_filename = "\hmm_trial_lvl_"; 
counter = 1;
for s = state_options
    try
        curr_table =  readtable(base_dir + hmm_filename + string(s) + "_1.xlsx","ReadVariableNames",1);
    catch
        continue
    end
    hmm_tables{counter} = curr_table;
    counter = counter + 1;
end

%% get best hmms + viz


current_features = ["pupil_diameter", "approach_rate",...
    "rew", "cost", "reaction_time", "num_guesses", "num_saccads"]; 

all_people_state_table = [];
all_ids = hmm_tables{1}.id;
ids = unique(all_ids(all_ids > 1000));
best_hmms = {};
best_funcs = {};
state_tables = {};
all_hmm_states = [];
all_state_funcs = [];
for j = 1 : length(ids)
    id = ids(j);

    try
        [best_hmm_row, state_table, state_var, spider_outcome] = viz_states_in_best_hmm([], id, hmm_tables, all_data, filtered_behavior_table, current_features, 0);  
        [state_funcs] = create_state_psychs(state_table,state_var,0);
        all_state_funcs = [all_state_funcs state_funcs];
        best_funcs{j} = state_funcs;
        best_hmms{j} = best_hmm_row;
        state_tables{j} = state_table;
        all_hmm_states = [all_hmm_states; spider_outcome];
        close all
    catch
        continue
    end

end

compare_state_psychs_to_existing_clusters("all_clusters_subject.xlsx",all_state_funcs)
compare_state_psychs_to_existing_clusters("all_clusters.xlsx",all_state_funcs)

%% 

figure

unique_tasks = unique(all_clusters.experiment);
colors = distinguishable_colors(length(unique_tasks));

for j = 1:length(unique_tasks)
    task = unique_tasks(j);
    task_sessions = all_clusters(string(all_clusters.experiment) == task, :);
    c = colors(j,:);
    scatter3(task_sessions.clusterX, task_sessions.clusterY, task_sessions.clusterZ, 20, c)
    hold on
end

legend(unique_tasks)

%%

current_features = ["pupil_diameter", "approach_rate",...
    "rew", "cost", "reaction_time", "num_guesses", "num_saccads"]; 

no_good_fit = 0;
relaxed_state_funcs = [];
for i = 1:length(best_hmms)
    curr_best_hmms = best_hmms{i};
    if ~isempty(curr_best_hmms)
        [best_hmm_row, state_tables, state_vars, spider_outcome] = viz_states_in_best_hmm(curr_best_hmms, id, hmm_tables, all_data, filtered_behavior_table, current_features, 0);   
        for k = 1:length(state_tables)
            state_table = state_tables{k};
            state_var = state_vars{k};
            try
                [state_funcs] = create_state_psychs(state_table,state_var,0);
                close all
            catch
                continue
                no_good_fit = no_good_fit + 1;
            end
            relaxed_state_funcs = [relaxed_state_funcs state_funcs];
        end
    end
end

compare_state_psychs_to_existing_clusters("all_clusters_subject.xlsx",relaxed_state_funcs)

%%

num_clusters = 4;

coords = [all_trial_table.x_coord,all_trial_table.y_coord,all_trial_table.z_coord];

figure
scatter3(coords(:,1), coords(:,2), coords(:,3))

[index,V,D] = spectralcluster(coords,num_clusters,'Method','euclidean');
unique_indexes = unique(index);

all_trial_table.dm_space_id = index;

figure
for k = 1:length(unique_indexes)
    dm_space_table = all_trial_table(all_trial_table.dm_space_id == k, :);

    nexttile
    make_dec_making_plots(dm_space_table,"","",1,0,0,"",0)
    title("map for cluster " + k)

end

figure
colors = distinguishable_colors(num_clusters);
scats = [];
for m = 1:length(unique_indexes)
    dm_space_table = all_trial_table(all_trial_table.dm_space_id == m, :);

    scat = scatter3(dm_space_table.x_coord, dm_space_table.y_coord, dm_space_table.z_coord, 100, colors(m,:), 'X');
    scats = [scats; scat];
    hold on
end
legend(scats)
