function best_hmm_row = get_best_hmm_per_person(all_hmms, id)

hmm_table = all_hmms(all_hmms.id == string(id), :);

mpc_thresh = 0.7;
mpc_table = hmm_table(hmm_table.mpcs_1 > mpc_thresh | hmm_table.mpcs_2 > mpc_thresh, :);

updated_hmm_table = [];
for j = 1:height(mpc_table)
    hmm_row = mpc_table(j, :);
    num_states = hmm_row.num_states;
    names = "t_" + (1:num_states*num_states);
   % t_matrix = hmm_row(:, ismember(hmm_row.Properties.VariableNames, names));
   % dead_transitions = length(find(t_matrix{1,:} <= 0.001));
   % hmm_row.num_dead_t_states = dead_transitions;
    updated_hmm_table = [updated_hmm_table; hmm_row];
end

sorted_table = sortrows(updated_hmm_table,["bic"],"ascend"); % get_best_hmm_per_person

best_hmm_row = sorted_table(1, :);
end