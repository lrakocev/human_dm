function [input_table,states] = compare_to_og_seq(hmm_row, all_data)

id = hmm_row.id;
input_table = all_data(all_data.subjectidnumber == id, :);

num_states = hmm_row.num_states;
granularity = hmm_row.granularity;

t = get_matrix_from_row(hmm_row, "t", num_states*num_states, num_states);
e = get_matrix_from_row(hmm_row, "e", num_states*granularity, granularity);
symbols = string(1:granularity);

variable_names = hmm_row.Properties.VariableNames;
feature_cols = string(variable_names(contains(variable_names,"features")));
features = string(table2array(hmm_row(:,feature_cols)));

seq_table = get_sequence_for_hmm(input_table, features, granularity);

seqs = [];
for i = 1:length(features)
    feature = features(i);
    seq = seq_table.(string(feature));
    seqs = [seqs seq];   
    seq_table = renamevars(seq_table, feature, feature +"_seq");
end

seqs = string(seqs');

input_table = [input_table seq_table];

[states, p_states] = HMM_decode(seqs, t, e, symbols);

for j = 1:length(states)
    input_table.("state_" + string(j)) = states{j}';
end

end