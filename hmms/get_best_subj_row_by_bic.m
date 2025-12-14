function best_hmm_row = get_best_subj_row_by_bic(hmm_tables, all_data, id)

best_bic = 100000;
for i = 1:length(hmm_tables)
    hmm_row = get_best_hmm_per_person(hmm_tables{i}, all_data, id);
    curr_bic = hmm_row.bic;
    if curr_bic < best_bic
        best_bic = curr_bic;
        best_hmm_row = hmm_row;
    end
end
end
