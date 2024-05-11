function plot_heatmap(summary_table,save_to)

heatmap(summary_table,'t1c1','t2c2','ColorVariable','dist_from_mean')
title('heatmap of std devs from mean of likelihood of y given x')
xlabel("given task + cluster")
ylabel("task + cluster")
colormap('default')
savefig(save_to + "heatmap_of_stds.fig")

figure
heatmap(summary_table,'t1c1','t2c2','ColorVariable','sample_mean')
title('heatmap of mean values of likelihood of y given x')
xlabel("given task + cluster")
ylabel("task + cluster")
colormap('default')
savefig(save_to + "heatmap_of_means.fig")

masked_std_devs = rowfun(@apply_mask,summary_table,"InputVariables",...
    "dist_from_mean","OutputVariableNames","dist_from_mean_masked_1_5");
summary_table = [summary_table masked_std_devs];

figure
heatmap(summary_table,'t1c1','t2c2','ColorVariable','dist_from_mean_masked_1_5')
title('heatmap of (highlighted >1.5) std devs from mean of likelihood of y given x')
xlabel("given task + cluster")
ylabel("task + cluster")
colormap('default')
savefig(save_to + "heatmap_of_stds_masked_1_5.fig")

function dist_from_mean = apply_mask(dist_from_mean)

if (abs(dist_from_mean) < 1.5)
    dist_from_mean = 0;
end
end
end