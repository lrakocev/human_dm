function [cluster_arr] = calc_reaction_time_cluster(gaze_data,num_clusters)
 
idx = spectralcluster(gaze_data,num_clusters);

num_clusters = length(unique(idx));
scatters = [];
colors = distinguishable_colors(num_clusters);

for j=1:num_clusters
    current_color = colors(j,:);
    indexes = idx == j;
    scatter(gaze_data(indexes,1),gaze_data(indexes,2),[],current_color);
    hold on;
end

cluster_arr = [gaze_data idx];

end