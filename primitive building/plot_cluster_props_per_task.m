function plot_cluster_props_per_task(hum_table, story_types, save_to)

for i = 1:length(story_types)
    task = story_types(i);

    task_table = hum_table(hum_table.experiment == task, :);

    counts = groupcounts(task_table, 'cluster_number');
    props = counts.Percent;

    bar(1:length(props), props)
    title("cluster props for " + task)
    set(gcf,'renderer','Painters')
    xlabel('cluster number')
    ylabel('proportion of pts in cluster')
    saveas(gcf, save_to + "\cluster_props_" + task, 'fig')
    saveas(gcf, save_to + "\cluster_props_" + task, 'svg')
end
end

