function avg_psych = get_avg_psych(cluster_table)

lvl_1 = cluster_table(cluster_table.rew == 1, :).approach_rate;
lvl_2 = cluster_table(cluster_table.rew == 2, :).approach_rate;
lvl_3 = cluster_table(cluster_table.rew == 3, :).approach_rate;
lvl_4 = cluster_table(cluster_table.rew == 4, :).approach_rate;

mean_lvl_1 = mean(lvl_1, 'omitnan');
mean_lvl_2 = mean(lvl_2, 'omitnan');
mean_lvl_3 = mean(lvl_3, 'omitnan');
mean_lvl_4 = mean(lvl_4, 'omitnan');

x = [1,2,3,4];
y = [mean_lvl_1, mean_lvl_2, mean_lvl_3, mean_lvl_4];

count = 1;
r = 0;
not_same = 0;
while (count < 20 && r < 0.75) || not_same < 1
    [avg_psych, r] = fit_sigmoid(x,y,"r");
    avg_pts = avg_psych([1 2 3 4]);
    not_same = sum(diff(avg_pts));
end

end