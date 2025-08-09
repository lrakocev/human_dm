function avg_psych = get_avg_rat_psych(cluster_table)

lvl_1 = cluster_table.y4;
lvl_2 = cluster_table.y3;
lvl_3 = cluster_table.y2;
lvl_4 = cluster_table.y1;

mean_lvl_1 = mean(lvl_1, 'omitnan');
mean_lvl_2 = mean(lvl_2, 'omitnan');
mean_lvl_3 = mean(lvl_3, 'omitnan');
mean_lvl_4 = mean(lvl_4, 'omitnan');

x = [1,2,3,4];
y = [mean_lvl_1, mean_lvl_2, mean_lvl_3, mean_lvl_4];

count = 1;
r = 0;
not_same = 0;
while (count < 10 && r < 0.75) || abs(not_same*100) < 1
    [avg_psych, r] = fit_sigmoid(x,y,"r");
    avg_pts = avg_psych([1 2 3 4]);
    not_same = sum(diff(avg_pts));
    count = count + 1;
end

end