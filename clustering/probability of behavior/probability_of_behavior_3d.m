function probability_of_behavior_3d(all_psych_data, story_type, save_to)
figure 
%{
max_x = round(max(all_psych_data.clusterX));
min_x = round(min(all_psych_data.clusterX));
max_y = round(max(all_psych_data.clusterY));
min_y = round(min(all_psych_data.clusterY));
max_z = round(max(all_psych_data.clusterZ));
min_z = round(min(all_psych_data.clusterZ));

% setting up to show the space of all possible combinations
for x = min_x:max_x
    for y = min_y:max_y
        for z = min_z:max_z
            scatter3(x,y,z,10,'b')
            hold on
        end
    end
end
%}

story_psychs = all_psych_data(all_psych_data.story_type == story_type, :);
num_clusters = max(story_psychs.idx);

tot_pts = height(story_psychs);
for i = 1:num_clusters
    cluster_psychs = story_psychs(story_psychs.idx == i, :);
    mean_x = mean(cluster_psychs.clusterX, 'omitnan');
    mean_y = mean(cluster_psychs.clusterY, 'omitnan');
    mean_z = mean(cluster_psychs.clusterZ, 'omitnan');

    tot_in_cluster = height(cluster_psychs);
    prob = tot_in_cluster / tot_pts;

    scatter3(mean_x, mean_y, mean_z, prob*1000, 'r','filled')
    hold on
end

title('probability of cluster for ' + story_type)
xlabel('log(abs(max))')
ylabel('log(abs(shift))')
zlabel('log(abs(slope))')
savefig(save_to + "\prob_of_behavior_" + story_type + ".fig")

end