function new_table = get_interactions(sesh_table)

labels = unique(sesh_table.clusterLabels);
new_table = [];
for i = 1:length(labels)
    label = labels(i);
    label_table = sesh_table(sesh_table.clusterLabels == label, :);
    r_interact = get_r_overlap(label_table);
    c_interact = get_c_overlap(label_table);
    label_table.r_interact = repelem(r_interact, height(label_table), 1);
    label_table.c_interact = repelem(c_interact, height(label_table), 1);
    new_table = [new_table; label_table];
end

end

function space = get_r_overlap(sesh_table)

areas = [];
for r = 1:4
    r_table = sesh_table(sesh_table.rew == r, :);
    curr_apprs = r_table.approach_rate;
    area = mean(curr_apprs);
    areas = [areas; area];
end

white_space = diff(areas);
space = median(white_space);

end

function space = get_c_overlap(sesh_table)

areas = [];
for c = 4:-1:1
    c_table = sesh_table(sesh_table.cost == c, :);
    curr_apprs = c_table.approach_rate;
    area = mean(curr_apprs);
    areas = [areas; area];
end

white_space = diff(areas);
space = median(white_space);

end

