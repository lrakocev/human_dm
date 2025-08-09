function plot_cluster_variance(prim_table, save_to, want_save)

clusters = unique(prim_table.idx);

for i = 1:length(clusters)
    c = clusters(i);
    cluster_table = prim_table(prim_table.idx == c, :);

    avg_psych = get_avg_psych(cluster_table);

    diffs = cluster_table.diffs_from_cluster_avg;
    avg_diffs = abs(mean(diffs));

    x = [1 2 3 4];
    mean_pts = avg_psych([1 2 3 4])';

    above_mean = mean_pts + avg_diffs;
    below_mean = mean_pts - avg_diffs;

    x2 = [x, fliplr(x)];
    inBetween = [above_mean, fliplr(below_mean)];

    figure(i)
    fill(x2, inBetween, [0.3010 0.7450 0.9330]);
    hold on 
    plot(avg_psych)
    hold off

    title("cluster " + string(i))
    if want_save
        set(gcf,'renderer','Painters')
        saveas(gcf,save_to+"\cluster_" + string(i) + "_var", "fig")
        saveas(gcf,save_to+"\cluster_" + string(i) + "_var", "svg")
    end
end

end

