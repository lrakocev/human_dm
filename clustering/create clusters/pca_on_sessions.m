function sessions_pca = pca_on_sessions(session_data, want_2d_map)

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

all_session_apprs = [];
for k = 1:length(all_session_data)
    curr_sesh = all_session_data{k};

    if isempty(curr_sesh)
        continue
    else
        if ~want_2d_map
            for c = 1:4
                appr_per_r = [];
                for_c_lvl = curr_sesh(curr_sesh.cost == c, :);
                apprs_across_c_lvl = sortrows(for_c_lvl, "rew");
    
                if height(apprs_across_c_lvl) == 4
                    appr_per_r = [appr_per_r apprs_across_c_lvl.approach_rate'];
                    all_session_apprs = [all_session_apprs; appr_per_r];
                else
                    continue
                end
            end
        else
            apprs_in_order = []; %zeros(4);
            for r = 1:4
                for c = 1:4
                    curr_row_appr = mean(curr_sesh(curr_sesh.cost == c & curr_sesh.rew == c, :).approach_rate, 'omitnan');
                   % apprs_in_order(r,c) = curr_row_appr;
                   apprs_in_order = [apprs_in_order; curr_row_appr/100];
                end
            end
           
            all_session_apprs = [all_session_apprs; apprs_in_order'];
        end

    end
end

non_nan_sessions = all_session_apprs(~sum(isnan(all_session_apprs),2),:);

[coeff, score, latent] = pca(non_nan_sessions');
scatter3(coeff(:,1),coeff(:,2),coeff(:,3))
xlabel("pc1")
ylabel("pc2")
zlabel("pc3")
title("pcs of the 2d maps")
%[pcs] = get_new_pcs(non_nan_sessions,0);

end