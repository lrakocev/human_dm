function [num_guesses,reaction_time] = calc_num_guesses(gaze_data,word_length)

    filtered_idx = (gaze_data(:, 1) ~= -999 & gaze_data(:, 2) ~= -990);
    gaze_data = gaze_data(filtered_idx, :);

    location = get_et_locations(gaze_data, word_length);


    diffs = diff(gaze_data);
    abs_diffs = abs(diffs);

    [x_pks, x_loc] = findpeaks(abs_diffs(:,1));
    [y_pks, y_loc] = findpeaks(abs_diffs(:,2));

    green_idx = find(location == "g");
   
    diffs_in_green = diff(green_idx);
    big_diffs_in_green = (diffs_in_green <= 2);
    shifted_diffs = [0; big_diffs_in_green];
    diffs_of_shift = diff(shifted_diffs);
    shifted_full = [diffs_of_shift; 0];

    potential_streak_start_idx = find(shifted_full == 1);
    end_idx = [find(shifted_full == -1); length(green_idx)];
    streak_lengths = [abs(potential_streak_start_idx - end_idx)];

    min_streak_length = 5;
    streak_start_idx = potential_streak_start_idx(streak_lengths >= min_streak_length);
    streak_starts = green_idx(streak_start_idx);
    
    % in the 2 timesteps before the streak
    idx_right_before_streak = [streak_starts - 1; streak_starts - 2];

    % if there's a change in x or y before the streak 
    x_peaks_preceding_streak = intersect(x_loc, idx_right_before_streak);
    y_peaks_preceding_streak = intersect(y_loc, idx_right_before_streak);

    peaks_preceding_streaks = unique([x_peaks_preceding_streak;y_peaks_preceding_streak]);

    % want there to always be a change in coord before the streak
    num_guesses = min(length(peaks_preceding_streaks), length(streak_starts));

   % debugging_guesses(diffs, location, num_guesses)

    if ~isempty(streak_starts)
        reaction_time = length(gaze_data) - streak_starts(1);
    else
        reaction_time = 0;
    end
end

function debugging_guesses(diffs, location, num_guesses)

figure
plot(1:length(diffs), diffs(:,1),'r')
hold on
plot(1:length(diffs), diffs(:,2),'b')
hold on
for i = 1:length(location)
    scatter(i, 0, 10,location{i})
    hold on
end
hold off
title("num guessing periods: " + string(num_guesses))

figure 
plot(gaze_data(:,1),gaze_data(:,2),'--')

figure
scatter(gaze_data(:,1),gaze_data(:,2)) 

end
