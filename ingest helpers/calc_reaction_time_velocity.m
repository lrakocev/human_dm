function [cluster_arr] = calc_reaction_time_velocity(gaze_data,num_clusters)
 
diffs = diff(gaze_data);
max_diff_in_y = max(diffs(:,2));

figure
plot(1:length(diffs),diffs)
hold on
for i = 1:length(location)
    scatter(i, 0,10,location{i})
    hold on
end

end