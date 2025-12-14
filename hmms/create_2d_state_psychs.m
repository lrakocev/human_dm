function [state_funcs,types] = create_2d_state_psychs(state_table,state_var)

cost_levels = 1/4:1/4:1;
reward_levels = 1/4:1/4:1;

unique_states = unique(state_table.(state_var));
state_funcs = {};
types = {};
for i = 1:length(unique_states)
    state = unique_states(i);
    curr_state_table = state_table(state_table.(state_var) == state, :);

    counter = 1;
    for r=1:length(reward_levels)
        for c=1:length(cost_levels)
            curr_row = curr_state_table(curr_state_table.cost == c & curr_state_table.rew == r,:);
            if ~isempty(curr_row)
                ps(counter) = mean(curr_row.approach_rate,'omitnan');
            else
                ps(counter) = NaN;
            end
            counter = counter+1;
        end
    end

    if anynan(ps)
        continue
    end
    
    ps = fillmissing(ps,'linear');%fill in any missing values with the mean of the rest
    ps = ps/100; %make the approach percentages in a decimal instead of a whole number
    
    func = fit_2d_sig_helper(reward_levels, cost_levels, ps');   
    type = "2d_sigmoid";

    state_funcs{i} = func;
    types{i} = type;

end

end