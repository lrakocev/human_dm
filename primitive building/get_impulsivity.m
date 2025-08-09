function new_table = get_impulsivity(sesh_table)

labels = unique(sesh_table.clusterLabels);
new_table = [];
for i = 1:length(labels)
    label = labels(i);
    label_table = sesh_table(sesh_table.clusterLabels == label, :);
    label_table.c_impulse = repelem(get_c_step(label_table), height(label_table), 1);
    label_table.r_impulse = repelem(get_r_step(label_table), height(label_table), 1);
    new_table = [new_table; label_table];
end
end

function impulse = get_r_step(sesh_table)

apprs = [];
for r = 1:4
    r_table = sesh_table(sesh_table.rew == r, :);
    avg_appr = mean(r_table.approach_rate, 'omitnan');
    apprs = [apprs; avg_appr];
end
lvls = [1:4];
impulse = apprs \ lvls';

end

function impulse = get_c_step(sesh_table)

apprs = [];
for c = 1:4
    c_table = sesh_table(sesh_table.cost == c, :);
    avg_appr = mean(c_table.approach_rate, 'omitnan');
    apprs = [apprs; avg_appr];
end

lvls = [1:4];
impulse = apprs \ lvls';

end
