function new_table = get_interactions(sesh_table, clusterLabel)

labels = unique(sesh_table.(clusterLabel));
new_table = [];
for i = 1:length(labels)
    label = labels(i);
    label_table = sesh_table(sesh_table.(clusterLabel) == label, :);
    r_interact = get_r_overlap(label_table);
    c_interact = get_c_overlap(label_table);
    label_table.r_interact = repelem(r_interact, height(label_table), 1);
    label_table.c_interact = repelem(c_interact, height(label_table), 1);
    new_table = [new_table; label_table];
end

end

function space = get_r_overlap(sesh_table)

areas = [];
for r = 1:3
    r_table = sesh_table(sesh_table.rew == r, :);

    % remove duplicates
    [~, unique_indices] = unique(r_table.rew, 'stable');
    r_table_updated = r_table(unique_indices, :);

    curr_apprs = r_table_updated.approach_rate;
    area = mean(curr_apprs,'omitnan');
    areas = [areas; area];
end

white_space = diff(areas);
space = median(white_space);

end

function space = get_c_overlap(sesh_table)

areas = [];
for c = 4:-1:1
    c_table = sesh_table(sesh_table.cost == c, :);

    % remove duplicates
    [~, unique_indices] = unique(c_table.rew, 'stable');
    c_table_updated = c_table(unique_indices, :);

    curr_apprs = c_table_updated.approach_rate;
    area = mean(curr_apprs);
    areas = [areas; area];
end

white_space = diff(areas);
space = median(white_space);

end

