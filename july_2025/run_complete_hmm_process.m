function [states, bic, mpcs, t, e] = run_complete_hmm_process(starting_input, data_type, granularity, features, num_states)

if ~isnan(str2double(data_type))
    input_table = starting_input(starting_input.subjectidnumber == str2double(data_type), :);
elseif data_type == "all"
    input_table = starting_input;
else
    input_table = starting_input(starting_input.story_type == data_type, :);
end

seq_table = get_sequence_for_hmm(input_table, features, granularity);

estimate_t = rand(num_states);
estimate_t = estimate_t ./ sum(estimate_t, 2);

estimate_e = rand(num_states, granularity);
estimate_e = estimate_e ./ sum(estimate_e, 2); 

[states, bic, mpcs, t, e] = run_hmm(seq_table, estimate_t, estimate_e);

end