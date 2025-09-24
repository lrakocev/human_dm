function [seq] = apply_threshold_to_seq(raw_seq, thresholds, symbols)

num_trials = length(raw_seq);
seq = [];
num_thresh = length(thresholds);

for i = 1:num_trials
    trial_val = raw_seq(i);
    
    binned = false;
    
    j = 1;
    while ~binned
        if j > num_thresh
            seq = [seq; symbols{end}];
            binned = true;
            continue
        end
        
        threshold = thresholds(j);
        
        if trial_val < threshold
            seq = [seq; symbols{j}];
            binned = true;
        end
        
        j = j + 1;
    end
end

end