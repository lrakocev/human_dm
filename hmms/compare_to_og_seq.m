function compare_to_og_seq(hmm_row, )

num_states = hmm_row.num_states;
granularity = hmm_row.granularity;

t = get_matrix_from_row("t", num_states^2, num_states);
e = get_matrix_from_row("e", num_states*granularity, granularity);
symbols = string(1:granularity);




[states, p_states] = HMM_decode(input_seq, t, e, symbols);

end

function matrix = get_matrix_from_row(prefix, size, reshape_by)

names = prefix + "_" + (1:size);
matrix_raw = hmm_row(:, ismember(hmm_row.Properties.VariableNames, names));
matrix = reshaped(matrix_raw, [], reshape_by);

end