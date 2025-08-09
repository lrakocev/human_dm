function new_table = get_mse(sesh_table)

labels = unique(sesh_table.clusterLabels);
new_table = [];
for i = 1:length(labels)
    label = labels(i);
    label_table = sesh_table(sesh_table.clusterLabels == label, :);
    mse = calc_mse(label_table);
    label_table.mse = repelem(mse, height(label_table), 1);
    new_table = [new_table; label_table];
end

end

function mse = calc_mse(sig_table)

lvl_1 = sig_table(sig_table.rew == 1, :).approach_rate;
lvl_2 = sig_table(sig_table.rew == 2, :).approach_rate;
lvl_3 = sig_table(sig_table.rew == 3, :).approach_rate;
lvl_4 = sig_table(sig_table.rew == 4, :).approach_rate;

mean_lvl_1 = mean(lvl_1, 'omitnan');
mean_lvl_2 = mean(lvl_2, 'omitnan');
mean_lvl_3 = mean(lvl_3, 'omitnan');
mean_lvl_4 = mean(lvl_4, 'omitnan');

xs = [1,2,3,4];
ys = [mean_lvl_1, mean_lvl_2, mean_lvl_3, mean_lvl_4];

% should all be the same function bc same label
a = (sig_table.rawX(1));
b = (sig_table.rawY(1));
c = (sig_table.rawZ(1));
sigmoid = @(x) (a/(1+b*exp(-c*(x))));
sig_fit = arrayfun(sigmoid,xs);
mse = sum((sig_fit-ys).^2)/length(ys);

end