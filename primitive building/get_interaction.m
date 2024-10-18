function new_table = get_interaction(sesh_table)

labels = unique(sesh_table.clusterLabels);
new_table = [];
for i = 1:length(labels)
    label = labels(i);
    label_table = sesh_table(sesh_table.clusterLabels == label, :);
    if ~isempty(label_table)
        updated_table = get_r_c_coeff(label_table);
        new_table = [new_table; updated_table];
    end
end

end

function sesh_table = get_r_c_coeff(sesh_table)

reg_coeff_r_min_c = sesh_table.r_min_c \ sesh_table.approach_rate;
sesh_table.r_min_c_coeff = repelem(reg_coeff_r_min_c, height(sesh_table), 1);

reg_coeff_r_plus_c = sesh_table.r_plus_c \ sesh_table.approach_rate;
sesh_table.r_plus_c_coeff = repelem(reg_coeff_r_plus_c,height(sesh_table), 1);

end