function new_table = get_sensitivity(sesh_table, cost_or_rew)

labels = unique(sesh_table.clusterLabels);
new_table = [];
for i = 1:length(labels)
    label = labels(i);
    label_table = sesh_table(sesh_table.clusterLabels == label, :);
    [p,t,stats,terms] = psychometric_anova(label_table, cost_or_rew);
    if cost_or_rew == "reward"
        label_table.reward_sensitivity = repelem(p, height(label_table), 1);
    else
        label_table.cost_sensitivity = repelem(p, height(label_table), 1);
    end
    new_table = [new_table; label_table];
end

end