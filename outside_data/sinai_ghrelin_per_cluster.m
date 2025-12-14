function mt_sinai_cluster_table = sinai_ghrelin_per_cluster(mt_sinai_trial_table, num_clusters)

mt_sinai_trial_table.cluster_idx = repelem(NaN, height(mt_sinai_trial_table), 1);
coords = [mt_sinai_trial_table.x_coord, mt_sinai_trial_table.y_coord, mt_sinai_trial_table.z_coord];

opt = fcmOptions(NumClusters = num_clusters);
[~,U,~,info] = fcm(coords,opt);

mpc = calculate_mpc(U);
maxU = max(U);

colors = distinguishable_colors(num_clusters);

figure;
scatters = [];
mt_sinai_cluster_table = [];
for j=1:num_clusters
    current_color = colors(j,:);
    indexes = find(U(j,:)==maxU);

    idx_rows = mt_sinai_trial_table(indexes, :);
    idx_rows.cluster_idx = repelem(j,height(idx_rows),1);
    mt_sinai_cluster_table = [mt_sinai_cluster_table; idx_rows];
    scatter_object = scatter3(idx_rows.x_coord,idx_rows.y_coord, idx_rows.z_coord, [],current_color);
    hold on
    scatters = [scatters; scatter_object];

end

legend(string(1:num_clusters)); 
xlabel("x coord");
ylabel("y coord");
zlabel("z coord")
title("clustering for mt sinai data, mpc = " + string(mpc) + ", num clusters = " + string(num_clusters))

ghrelin_table = readtable("K01_tracking.xlsx","Sheet","ghrelin-hormones","NumHeaderLines",0);
ghrelin_table.id = "K" + ghrelin_table.K01_SUBID;

mt_sinai_hormone_table = outerjoin(mt_sinai_cluster_table, ghrelin_table, "MergeKeys", 1, "Keys", {'id'});
mt_sinai_hormone_table = mt_sinai_hormone_table(~isnan(mt_sinai_hormone_table.x_coord), :);

bars = [];
stds = [];

bars_estr = [];
stds_estr = [];

bars_test = [];
stds_test = [];
for k = 1:num_clusters
    cluster_table = mt_sinai_hormone_table(mt_sinai_hormone_table.cluster_idx == k, :);
    mean_ghr = mean(cluster_table.aGHR, 'omitnan');
    std_dev = std(cluster_table.aGHR, 'omitnan') / sqrt(height(cluster_table(~isnan(cluster_table.aGHR),:)));

    bars = [bars; mean_ghr];
    stds = [stds; std_dev];

    mean_estr = mean(cluster_table.Estradiol_pg_mL_, 'omitnan');
    std_dev_estr = std(cluster_table.Estradiol_pg_mL_, 'omitnan') / sqrt(height(cluster_table(~isnan(cluster_table.Estradiol_pg_mL_),:)));

    bars_estr = [bars_estr; mean_estr];
    stds_estr = [stds_estr; std_dev_estr];

    mean_test = mean(cluster_table.TotalTestos_ng_dL_, 'omitnan');
    std_dev_test = std(cluster_table.TotalTestos_ng_dL_, 'omitnan') / sqrt(height(cluster_table(~isnan(cluster_table.TotalTestos_ng_dL_),:)));

    bars_test = [bars_test; mean_test];
    stds_test = [stds_test; std_dev_test];


end

figure
bar(1:num_clusters, bars)
hold on
errorbar(bars,stds)
xlabel("behavioral clusters")
ylabel("ghr levels")
hold off

figure
bar(1:num_clusters, bars_estr)
hold on
errorbar(bars_estr,stds_estr)
xlabel("behavioral clusters")
ylabel("estr levels")
hold off

figure
bar(1:num_clusters, bars_test)
hold on
errorbar(bars_test,stds_test)
xlabel("behavioral clusters")
ylabel("test levels")
hold off
end