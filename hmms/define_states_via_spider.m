function all_state_mean = define_states_via_spider(state_table, input_features, state_var, want_view)

num_states = length(unique(state_table.(state_var)));

all_state_mean = [];
all_state_std = {};
state_names = [];
for j = 1 : num_states
    
    curr_state_table = state_table(state_table.(state_var) == j, :);

    feature_seqs = curr_state_table(:, input_features);

    state_mean = mean(feature_seqs, 'omitnan');
    state_std = std(feature_seqs);

    mean_arr = state_mean{1,:};
    std_arr = state_std{1,:};

    all_state_mean = [all_state_mean; mean_arr];
    all_state_std{j} = [std_arr; std_arr];
    state_names = [state_names; "state " + j];
    
end

id = state_table.subjectidnumber(1);

if want_view
    figure
    spider_plot(all_state_mean,...
        'AxesLabels', cellstr(input_features),...
        'AxesShaded', 'on',...
        'AxesShadedLimits', all_state_std,...
        'AxesShadedTransparency', 0.1);
    
    legend(state_names)
    title("subjectidnumber: " + string(id))
end

end