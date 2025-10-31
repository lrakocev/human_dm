function [all_times, participant_avgs] = calculate_participant_trial_timing(all_data)

start_table = rowfun(@clean_date, all_data, "InputVariables", ...
    "trial_start", "OutputVariableNames", "clean_date");

end_table = rowfun(@clean_date, all_data, "InputVariables", ...
    "trial_end", "OutputVariableNames", "clean_date");

all_data.clean_start = start_table.clean_date;
all_data.clean_end = end_table.clean_date;

all_data.trial_length = milliseconds(all_data.clean_end - all_data.clean_start);

unique_ids = unique(all_data.subjectidnumber);

%all_data.session = all_data.subjectidnumber + "/" + all_data.story_type + "/" + all_data.story_num;

all_times = [];
participant_avgs = [];
for i = 1:length(unique_ids)
    id = unique_ids(i);

    id_table = all_data(all_data.subjectidnumber == id, :);
    unique_sessions = unique(id_table.story_num);

    participant_times = [];
    for j = 1:length(unique_sessions)
        sesh = unique_sessions(j);
        sesh_table = id_table(id_table.story_num == sesh, :);

        ordered = sortrows(sesh_table,"clean_start","ascend");

        all_starts = ordered.clean_start;
        all_ends = ordered.clean_end;

        et_timesteps = sesh_table.num_et_timesteps;
        sesh_length = sum(et_timesteps ); %minutes(max(all_ends) - min(all_starts));

        if sesh_length > 0
            participant_times = [participant_times; sesh_length];
            all_times = [all_times; sesh_length];
        end
    end

    participant_avgs = [participant_avgs; mean(participant_times, 'omitnan')];

end

figure
histogram(all_times, 20) %,'BinLimits', [0 1]);
title("all sessions (time steps)")

figure
histogram(participant_avgs, 20) %,'BinLimits', [0 1]);
title("participant session avgs (time steps)")

end