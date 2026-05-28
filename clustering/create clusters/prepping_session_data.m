function raw_sesh_data_across_rew = prepping_session_data(session_data, want_2d_map)

if isempty(session_data)
    load("final_hum_data_dec25.mat")
    
    [all_data_w_story] = add_story_column_loop({all_data});
    all_data_w_story = all_data_w_story{1};
    
    [all_trial_data_w_story] = add_story_column_loop(all_trial_data);
    
    [N_trial_data, idxs] = filter_hum_appr_data(all_trial_data_w_story, 16);
    
    all_story_types = unique(r_ratings.tasktype);
    for i = 1:length(all_story_types)
        story = all_story_types(i);
        task_session_data = sessions_by_tasktype(N_trial_data, story);
        session_data{i} = task_session_data;
    end
end

all_session_data = [];
for j = 1:length(session_data)
    all_session_data = [all_session_data session_data{j}];
end

raw_sesh_data_across_rew = [];
for k = 1:length(all_session_data)
    curr_sesh = all_session_data{k};

    if isempty(curr_sesh)
        continue
    else
        if ~want_2d_map
            for c = 1:4
                appr_per_r = [];
                % mean_r_appr = mean(curr_sesh(curr_sesh.rew == r, :).approach_rate, 'omitnan');
                for_c_lvl = curr_sesh(curr_sesh.cost == c, :);
                apprs_across_c_lvl = sortrows(for_c_lvl, "rew");
    
                if height(apprs_across_c_lvl) == 4
                    appr_per_r = [appr_per_r apprs_across_c_lvl.approach_rate'];
                    raw_sesh_data_across_rew = [raw_sesh_data_across_rew; appr_per_r];
                else
                    continue
                end
            end
        else
            apprs_in_order = [];
            for r = 1:4
                for c = 1:4
                    curr_row_appr = mean(curr_sesh(curr_sesh.cost == c & curr_sesh.rew == c, :).approach_rate, 'omitnan');
                    apprs_in_order = [apprs_in_order curr_row_appr];
                end
            end
            raw_sesh_data_across_rew = [raw_sesh_data_across_rew; apprs_in_order];
        end

    end
end

end