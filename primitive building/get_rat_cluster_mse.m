function new_table = get_rat_cluster_mse(sesh_table)

% compare cluster average to all psychs in cluster
new_table = [];
clusters = unique(sesh_table.idx);
for k = 1:length(clusters)
    c = clusters(k);
    cluster_table = sesh_table(sesh_table.idx == c, :);    
    avg_psych = get_avg_rat_psych(cluster_table);

    labels = unique(cluster_table.clusterLabels);
    for i = 1:length(labels)
        label = labels(i);
        label_table = cluster_table(cluster_table.clusterLabels == label, :);
        [mse, diffs] = compare_avg_to_indiv(avg_psych, label_table);
       
        label_table.cluster_mse = repelem(mse, height(label_table), 1);
        label_table.diffs_from_cluster_avg = repelem(diffs, height(label_table), 1);
        new_table = [new_table; label_table];
    end
end

end