function matrix = get_matrix_from_row(hmm_row, prefix, size, reshape_by)

names = prefix + "_" + (1:size);
matrix_raw = hmm_row(:, ismember(hmm_row.Properties.VariableNames, names));
values = matrix_raw{1,:};
matrix = reshape(values, [], reshape_by);

end