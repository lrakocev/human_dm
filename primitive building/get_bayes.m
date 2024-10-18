function new_table = get_bayes(sesh_table)

labels = unique(sesh_table.clusterLabels);
new_table = [];
for i = 1:length(labels)
    label = labels(i);
    label_table = sesh_table(sesh_table.clusterLabels == label, :);
    if ~isempty(label_table)
        r_bayes_table = calc_r_bayes(label_table);
        c_bayes_table = calc_c_bayes(r_bayes_table);
        new_table = [new_table; c_bayes_table];
    end
end

end

function new_table = calc_c_bayes(sesh_table)

new_table = [];
for r = 1:4
    rew_table = sesh_table(sesh_table.rew == r, :);
    table_sum = sum(rew_table.approach_rate);
    rew_table.rew_constant_sum = repelem(table_sum, height(rew_table), 1);
    for c = 1:4
        single_row = rew_table(rew_table.cost == c, :);
        val = single_row.approach_rate / table_sum;
        single_row.c_bayes = val;
        new_table = [new_table; single_row];
    end
end
end


function new_table = calc_r_bayes(sesh_table)

new_table = [];
for c = 1:4
    cost_table = sesh_table(sesh_table.cost == c, :);
    table_sum = sum(cost_table.approach_rate);
    cost_table.cost_constant_sum = repelem(table_sum, height(cost_table), 1);
    for r = 1:4
        single_row = cost_table(cost_table.rew == r, :);
        val = single_row.approach_rate / table_sum;
        single_row.r_bayes = val;
        new_table = [new_table; single_row];
    end
end
end

