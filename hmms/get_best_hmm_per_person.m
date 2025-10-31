function best_hmm_row = get_best_hmm_per_person(all_hmms, all_data, id)

hmm_table = all_hmms(all_hmms.id == (id), :);

mpc_thresh = 0.7;
mpc_table = hmm_table(hmm_table.mpcs_1 > mpc_thresh | hmm_table.mpcs_2 > mpc_thresh, :);

updated_hmm_table = [];
for j = 1:height(mpc_table)
    hmm_row = mpc_table(j, :);
    num_states = hmm_row.num_states;

    [~,states] = compare_to_og_seq(hmm_row, all_data);
    num_states_decoded = max(length(unique(states{1})), length(unique(states{2})));

    if num_states_decoded < num_states
        continue
    end

    updated_hmm_table = [updated_hmm_table; hmm_row];
end

sorted_table = sortrows(updated_hmm_table,'bic',"ascend"); % get_best_hmm_per_person

best_hmm_row = sorted_table(1, :);
end