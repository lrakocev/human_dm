function [states, bic, mpcs, t, e] = run_hmm_on_gaze(raw_gaze, num_lvls, num_states)

filter = replace(string(raw_gaze), '[-999, -999],','');
lvl1 = replace(filter,'[','');
lvl2 = replace(lvl1,']','');
split_list = split(lvl2, ",");
clean_seq = str2double(split_list);
reshaped = reshape(clean_seq, 2, [])'; 

symbols = (1:num_lvls);
symbol_chars = num2cell(symbols); 

features = ["x", "y"];
for i = 1:2
    feature = features(i);
    coords = reshaped(:,i);
    thresholds = get_thresh_lvls(coords, num_lvls);
    seq = apply_threshold_to_seq(coords, thresholds, symbol_chars);
    seq_table.(feature) = seq;
end

seq_table = struct2table(seq_table);

estimate_t = rand(num_states);
estimate_t = estimate_t ./ sum(estimate_t, 2);

estimate_e = rand(num_states, num_lvls);
estimate_e = estimate_e ./ sum(estimate_e, 2); 

[states, bic, mpcs, t, e] = run_hmm(seq_table, estimate_t, estimate_e);

end