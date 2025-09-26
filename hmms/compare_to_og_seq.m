function input_table = compare_to_og_seq(hmm_row, all_data)

% getting the input table is about to be a bitch because i am STUPID
data_idx = hmm_row.actual_data_idx;
input_table = all_data{data_idx};

num_states = hmm_row.num_states;
granularity = hmm_row.granularity;

t = get_matrix_from_row(hmm_row, "t", num_states*num_states, num_states);
e = get_matrix_from_row(hmm_row, "e", num_states*granularity, granularity);
symbols = string(1:granularity);

features = string([hmm_row.features]);

seq_table = get_sequence_for_hmm(input_table, features, granularity);

seqs = [];
for i = 1:length(features)
    feature = features(i);
    seq = seq_table.(string(feature));
    seqs = [seqs seq];   
end

seqs = string(seqs');

[states, p_states] = HMM_decode(seqs, t, e, symbols);

for j = 1:length(states)
    input_table.("state_" + string(i)) = states{i}';
end

end

function matrix = get_matrix_from_row(hmm_row, prefix, size, reshape_by)

names = prefix + "_" + (1:size);
matrix_raw = hmm_row(:, ismember(hmm_row.Properties.VariableNames, names));
values = matrix_raw{1,:};
matrix = reshape(values, [], reshape_by);

end