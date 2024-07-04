function appr_rate = weiner_process_sim(drift_rate)

max_t = 5;
n_sim = 100;
noise = 10;
threshold = 2;
tstep = .01; % in seconds
n_action = length(drift_rate);
max_tsteps = max_t/tstep;

weiner_process_progress = zeros(n_sim, n_action, max_tsteps);
[actions_taken,t_to_decision_dat] = deal(nan(n_sim,1));


for i=1:n_sim
    for j=2:max_tsteps
        weiner_process_progress(i,:,j) = ...
            squeeze(weiner_process_progress(i,:,j-1)) + ...
            tstep * (drift_rate + noise*randn(1,n_action));
    end
    % when does the first line cross the threshold?
    tsteps_to_decision = ...
        find(any(weiner_process_progress(i,:,:) > threshold),1);

   
    % if the line doesn't cross, set it to the max time 
    if isempty(tsteps_to_decision)
        tsteps_to_decision = nan;
    end

    
    t_to_decision_dat(i) = tstep*tsteps_to_decision;
end

approach = sum(~isnan(t_to_decision_dat));
total = height(t_to_decision_dat);

appr_rate = approach / total * 100;

end


