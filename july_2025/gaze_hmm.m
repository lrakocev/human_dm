%% load gaze data

% load("gaze_data_for_debugging.mat")

gaze_table = [];
for i = 1:length(new_trial_data)
    gaze_table = [gaze_table; new_trial_data{i}];
end

gaze_table = gaze_table(gaze_table.left_gaze_coords ~= "" & gaze_table.left_gaze_coords ~= "[]", :);

%%

num_states = 2;
num_lvls = 3;
hmm_table = [];
for j = 1:height(gaze_table)
    gaze_row = gaze_table(i,:);
    raw_seq = gaze_row.left_gaze_coords{1};
    appr_rate = gaze_row.approach_rate;
    rew = gaze_row.rew;
    cost = gaze_row.cost;
    pupil_diam = gaze_row.pupil_diameter;
    for k = 1:100
        [states, bic, mpcs, t, e]  = run_hmm_on_gaze(raw_seq, num_lvls, num_states);
        row.state = states;
        row.bic = bic;
        row.mpcs = mpcs;
        row.t = t;
        row.e = e;
        row.rew = rew;
        row.cost = cost;
        row.pupil_diam = pupil_diam;
        row.appr = appr_rate;
        hmm_table = [hmm_table; row];
    end
end
hmm_table = struct2table(hmm_table, "AsArray", 1);