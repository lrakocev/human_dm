function plot_hmm_state_psychs(all_trial_table, num_clusters, type)

func_table = all_trial_table(all_trial_table.psych_type == type, :);

coords = ([func_table.x_coord,func_table.y_coord,func_table.z_coord]);

opt = fcmOptions(NumClusters=num_clusters);
[centers, U] = fcm(coords,opt);
maxU = max(U);

%func_table.dm_space_id = U;

figure
colors = distinguishable_colors(num_clusters);
scats = [];
for m = 1:num_clusters
    indexes = find(U(m,:)==maxU);
    dm_space_table = func_table(indexes, :);

    scat = scatter3(dm_space_table.x_coord, dm_space_table.y_coord, dm_space_table.z_coord, 100, colors(m,:));
    scats = [scats; scat];
    hold on
end
legend(scats)
xlabel("x param")
ylabel("y param")
zlabel("z param")
title("hmm states with psych defined by: " + type)

figure
for k = 1:num_clusters
    indexes = find(U(k,:)==maxU);
    dm_space_table = func_table(indexes, :);


    nexttile
    make_dec_making_plots(dm_space_table,"","",1,0,0,"",0)
    title("map for cluster " + k)

end



end