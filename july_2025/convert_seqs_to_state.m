function state_seq = convert_seqs_to_state(seq_table)

%all_combos = unique(seq_table, 'rows');
%state_names = "s" + string(1:height(all_combos))';

merged_seqs = mergevars(seq_table, seq_table.Properties.VariableNames);
joined_seq = convertvars(merged_seqs, 'Var1', @(x) join(x, ""));
joined_seq = renamevars(joined_seq, "Var1", "merged_state");

unique_states = unique(joined_seq);
state_names = "s" + string(1:height(unique_states))';

state_seq = changem(joined_seq.merged_state, state_names, unique_states.merged_state);

% mapping back


end