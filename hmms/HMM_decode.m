function [all_states, all_pstates] = HMM_decode(state_seq, T, E, symbols)

all_pstates = {};
all_states = {};
num_trials = length(state_seq);
for j = 1:height(state_seq)
    seq = state_seq(j,:);
    p_states = hmmdecode(seq, T, E, 'Symbols', symbols);  
    
    states = zeros(1, num_trials);
    
    for i = 1:num_trials
        state_dist = p_states(:, i);
        [~, index] = max(state_dist);
        states(i) = index;
    end

    all_pstates{j} = p_states;
    all_states{j} = states;
end

end