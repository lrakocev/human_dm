function new_table = get_appr_bias(sesh_table)

labels = unique(sesh_table.clusterLabels);
new_table = [];
for i = 1:length(labels)
    label = labels(i);
    label_table = sesh_table(sesh_table.clusterLabels == label, :);
    if ~isempty(label_table)
        mean_appr = mean(label_table.approach_rate, 'omitnan');
        max_appr = max(label_table.approach_rate);
        min_appr = min(label_table.approach_rate);
        label_table.mean_appr = repelem(mean_appr, height(label_table), 1);
        label_table.max_appr = repelem(max_appr, height(label_table), 1);
        label_table.min_appr = repelem(min_appr, height(label_table), 1);
        new_table = [new_table; label_table];
    end
end

end
