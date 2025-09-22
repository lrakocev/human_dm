function [saccads] = calc_num_saccads(gaze_data)

    filtered_idx = (gaze_data(:, 1) ~= -999 & gaze_data(:, 2) ~= -990);
    gaze_data = gaze_data(filtered_idx, :);

    klist = 5:40;
    myfunc = @(X,K)(kmeans(X,K));
    eva = evalclusters(gaze_data, myfunc, 'CalinskiHarabasz', 'klist', klist);
    saccads = eva.OptimalK;
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
