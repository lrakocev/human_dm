function create_decision_tree(state_table, input_features, state_num)

feature_seqs = state_table(:, input_features);
output_state = state_table.("state_" + state_num);

Mdl = fitctree(feature_seqs, output_state);

view(Mdl)
view(Mdl,'mode','graph')

end