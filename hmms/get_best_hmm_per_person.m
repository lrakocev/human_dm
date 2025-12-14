function best_hmm_row = get_best_hmm_per_person(all_hmms, all_data, id)

hmm_table = all_hmms(all_hmms.id == (id), :);

all_bics = hmm_table.bic;
mean_bic = mean(all_bics, 'omitnan');

% coarse filter by bic just to save some time
hmm_table = hmm_table(hmm_table.bic < mean_bic, :);

variable_names = hmm_table.Properties.VariableNames;
mpc_cols = variable_names(contains(variable_names,"mpcs"));

mpc_thresh = 0.7;

% not thorough for more 2 features but c'est la vie
if length(mpc_cols) == 1
    mpc_table = hmm_table(hmm_table.mpcs> mpc_thresh, :);
else
    % this is bc approach rate is the 4th col
    mpc_table = hmm_table(hmm_table.mpcs_4 > mpc_thresh, :);
end

updated_hmm_table = [];
for j = 1:height(mpc_table)
    hmm_row = mpc_table(j, :);
    num_states = hmm_row.num_states;

    try
        [~,states] = compare_to_og_seq(hmm_row, all_data);
    catch
        continue
    end

 
    plausible_states = [];    
    for j = 1:length(states)
        curr_states = states{j};
        [counts, unique_elements] = groupcounts(curr_states');
        if any(counts < 16) || length(unique_elements) < max(max(unique_elements),2)
            continue
        else
            plausible_states = [plausible_states; j];
        end
    end

    if isempty(plausible_states)
        continue
    end

    hmm_row.plausible_states = {plausible_states};

    updated_hmm_table = [updated_hmm_table; hmm_row];
end

sorted_table = sortrows(updated_hmm_table,'bic',"ascend"); 
best_hmm_row = sorted_table(1, :);
end