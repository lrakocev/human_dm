function probability_of_behavior_3d(all_psych_data, story_type, save_to)
figure 

story_psychs = all_psych_data(all_psych_data.story_type == story_type, :);
num_clusters = max(story_psychs.idx);

tot_pts = height(story_psychs);
for i = 1:num_clusters
    cluster_psychs = story_psychs(story_psychs.idx == i, :);
    if ~isempty(cluster_psychs)
        mean_x = mean(cluster_psychs.clusterX, 'omitnan');
        mean_y = mean(cluster_psychs.clusterY, 'omitnan');
        mean_z = mean(cluster_psychs.clusterZ, 'omitnan');
    
        tot_in_cluster = height(cluster_psychs);
        prob = tot_in_cluster / tot_pts;
    
        scatter3(mean_x, mean_y, mean_z, prob*1000, 'r','filled')
        hold on
    end
end

title('probability of cluster for ' + story_type)
xlabel('log(abs(max))')
ylabel('log(abs(shift))')
zlabel('log(abs(slope))')
set(gcf,'renderer','Painters')
savefig(save_to + "\prob_of_behavior_" + story_type + ".fig")

end