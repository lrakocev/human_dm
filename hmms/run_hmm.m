function [states, bic, mpcs, t, e] = run_hmm(seq_table, granularity, estimate_t, estimate_e)

features = seq_table.Properties.VariableNames;
seqs = [];
for i = 1:length(features)
    feature = features(i);
    seq = seq_table.(string(feature));
    seqs = [seqs seq];   
end

seqs = string(seqs');

N = length(estimate_t);
M = length(estimate_e);

symbols = string(1:granularity);

[t, e, logliks] = hmmtrain(seqs, estimate_t, estimate_e, 'Symbols', symbols, 'MAXITERATIONS', 300);

num_params = (N-1) + N*(N-1) + N*(M-1);
[~,bic] = aicbic(logliks(end), num_params, length(seqs));
[states, p_states] = HMM_decode(seqs, t, e, symbols);

mpcs = [];
for i = 1:length(p_states)
    mpc = calculate_mpc(p_states{i});
    mpcs = [mpcs; mpc];
end

end