function [curr_best_hmm_row, state_table, state_var, spider_outcome] = viz_states_in_best_hmm(curr_best_hmm_row, id, hmm_tables, all_data, filtered_behavior_table, current_features, want_spider)

if isempty(curr_best_hmm_row)
    curr_best_hmm_row = get_best_subj_row_by_bic(hmm_tables, all_data, id);
end

counter = 1;
for k = 1:height(curr_best_hmm_row)
    best_hmm_row = curr_best_hmm_row(k,:);

    plausible_states = best_hmm_row.plausible_states;
    state_table = compare_to_og_seq(best_hmm_row, all_data);
    
    variable_names = state_table.Properties.VariableNames;
    

    if length(plausible_states{1}) > 1
        plausible_state = plausible_states{1}(1);
    else
        plausible_state = plausible_states{1};
    end
    state_var = "state_" + plausible_state;
    counter = counter + 1;
    
    sub_table = filtered_behavior_table(filtered_behavior_table.subjectidnumber == id, :);
    
    state_joined_to_cluster = outerjoin(state_table, sub_table, 'MergeKeys',1,'Keys',...
        {'subjectidnumber','story_type','story_num','cost','rew','approach_rate'},'Type','Left','RightVariables','idx');
    state_joined_to_cluster = state_joined_to_cluster(~isnan(state_joined_to_cluster.state_1), :);
    
    if want_spider
    figure
    for idx = 1:best_hmm_row.num_states
        subplot(best_hmm_row.num_states,1,idx)
        histogram(state_joined_to_cluster(state_joined_to_cluster.(state_var) == idx, :).idx)
        title("STATE " + idx + " for subject " + id)
        xlabel("cluster number")
        ylabel("num trials")
        
    end
    end
    
    spider_outcome = define_states_via_spider(state_table, current_features, state_var, want_spider);
end


end