function  [N_trial_data, idxs] = filter_hum_appr_data(approach_data, N)

i = 1;
N_trial_data = {};
idxs = [];
for j = 1:length(approach_data)
    appr_table = approach_data{j};
    if height(appr_table) >= N
        idxs = [idxs; j];
        N_trial_data{i} = appr_table;
        i = i + 1;
    end
end