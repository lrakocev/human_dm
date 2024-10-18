function appr_bias = raw_features(all_data)

feat_table = [];
labels = unique(all_data.sesh_label,'stable');
for i = 1:length(labels)
    label = labels(i);
    label_table = all_data(all_data.sesh_label == label, :);
    appr_rates = label_table.approach_rate;
    max_appr = max(appr_rates);
    min_appr = min(appr_rates);
    med_appr = median(appr_rates,'omitnan');
    n = height(label_table);
    label_table.max_appr = create_arr(max_appr,n);
    label_table.min_appr = create_arr(min_appr,n);
    label_table.med_appr = create_arr(med_appr,n);

    label_table.lvl_1_appr = create_arr(mean(label_table(label_table.rew == 1, :).approach_rate, 'omitnan'),n);
    label_table.lvl_2_appr = create_arr(mean(label_table(label_table.rew == 2, :).approach_rate, 'omitnan'),n);
    label_table.lvl_3_appr = create_arr(mean(label_table(label_table.rew == 3, :).approach_rate, 'omitnan'),n);
    label_table.lvl_4_appr = create_arr(mean(label_table(label_table.rew == 4, :).approach_rate, 'omitnan'),n);

    feat_table = [feat_table; label_table];
end

sub_var = get_subj_var(feat_table);
impulse = get_impulsivity(sub_var);
range = get_range_across_lvls(impulse);
appr_bias = get_appr_bias(range);

end

function arr = create_arr(val, n)

arr = repelem(val, n, 1);
end

