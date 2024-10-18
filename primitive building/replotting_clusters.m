colors = distinguishable_colors(20);

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\prim_of_prims";
helper_replot(spectral_table, colors, save_to, "new human");
helper_replot(rat_table, colors, save_to, "new rat");

old_rat = readtable("C:\Users\lrako\OneDrive\Documents\human dm\rat_reward_choice.xlsx");
helper_replot(old_rat, colors, save_to, "old rat");

old_hum = readtable("C:\Users\lrako\OneDrive\Documents\human dm\all_session_updated.xlsx");
helper_replot(old_hum, colors, save_to, "old hum");

function helper_replot(input_table, colors, save_to, tit)

figure
unique_indices = unique(input_table.cluster_number);
hs = [];
for i = 1:length(unique_indices)
    cluster_table = input_table(input_table.cluster_number == i, :);
    
    h = scatter3(cluster_table.clusterX, cluster_table.clusterY, cluster_table.clusterZ,'o','MarkerEdgeColor',colors(i,:));
    hs = [hs; h];
    hold on
end
legend(hs)
title(tit)
hold off
savefig(save_to + "/" + tit + "_clusters.fig")
close all
end