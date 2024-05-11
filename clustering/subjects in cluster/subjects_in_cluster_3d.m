function subjects_in_cluster_3d(all_psych_data, story_type, y_max, save_to)

all_psych_data = all_psych_data(all_psych_data.story_type == story_type, :);

num_clusters = max(unique(all_psych_data.idx));
unique_ids = unique(all_psych_data.subjectidnumber);
cluster_stats = cell(1,num_clusters);
for i = 1:length(unique_ids)
    id = unique_ids(i);
    curr_table = all_psych_data(all_psych_data.subjectidnumber == id, :);
   
    clusters = curr_table.idx;
    [gc,gr] = groupcounts(clusters);
    sum_gc = sum(gc);
    gc = gc / sum_gc;
    for n = 1:length(gr)
        cluster = gr(n);
        stat = gc(n);
        cluster_stats{cluster} = [cluster_stats{cluster} ; stat];
    end
end

figure
max_vals = 0;
for i = 1:length(cluster_stats)
    cluster = cluster_stats{i};
    if ~isempty(cluster)
        num_vals = length(cluster);
        avg_percent = mean(cluster);
        scatter(i,avg_percent,num_vals*10,num_vals,'filled')
        if max_vals < num_vals
            max_vals = num_vals;
        end
        hold on
    end
end
title(story_type)
num_subjects = length(unique_ids);
subtitle("number of subjects: " + string(num_subjects))
colormap('default')
cb = colorbar;
ylabel(cb,'Number of subjects in cluster','FontSize',16,'Rotation',270);
cb.Ticks = [0 max_vals/2 max_vals];
clim([0 max_vals]);
ylim([0 y_max])
xlabel('cluster number')
ylabel('percent of subject sessions in cluster')
curtick = get(gca, 'xTick');
xticks(unique(round(curtick)));

savefig(save_to + "_" + string(story_type) + "_subjects_in_cluster_3d.fig")
end