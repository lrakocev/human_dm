function [states, bic, mpcs, t, e] = run_complete_hmm_process(input_table, granularity, features, num_states)

seq_table = get_sequence_for_hmm(input_table, features, granularity);

estimate_t = rand(num_states);
estimate_t = estimate_t ./ sum(estimate_t, 2);

estimate_e = rand(num_states, granularity);
estimate_e = estimate_e ./ sum(estimate_e, 2); 

[states, bic, mpcs, t, e] = run_hmm(seq_table, granularity, estimate_t, estimate_e);

end