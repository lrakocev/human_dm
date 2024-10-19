function plot_avg_task_cluster_psych(spectral_table, all_data, same_scale, story_types, save_to, use_cost)

totals = setup_for_avgs(all_data,story_types);
sesh_data = totals{5}; % includes all task data
clusters = unique(spectral_table.cluster_number);
for s = 1:length(clusters)
    cluster = clusters(s);
    cluster_table = spectral_table(spectral_table.cluster_number == cluster, :);
    psych_to_cluster = psychs_in_spec_cluster(cluster_table, use_cost);

    title = "cluster number " + string(cluster);
    create_avg_psych_task(sesh_data,psych_to_cluster,title,same_scale,save_to,use_cost)
end
end