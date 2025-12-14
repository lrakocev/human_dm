function analyze_transition_matrices(all_hmm_rows)

for i = 1:length(all_hmm_rows)
    hmm_row = all_hmm_rows{i};
    
    if ~isempty(hmm_row)
        id = hmm_row.id;
        num_states = hmm_row.num_states;
        granularity = hmm_row.granularity;
        
        t = get_matrix_from_row(hmm_row, "t", num_states*num_states, num_states);
        e = get_matrix_from_row(hmm_row, "e", num_states*granularity, granularity);

        t = round(t,4);
    
        figure
       
        heatmap(t)
        title("transition matrix heatmap for subj=" + id)

        figure
        
        g = digraph(t);
        plot(g,'EdgeLabel',g.Edges.Weight)
        title("transition matrix graph for subj=" + id)


    end
end

end