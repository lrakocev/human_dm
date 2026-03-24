function new_mt_sinai_cluster_table = cluster_sinai_w_utep(existing_table, mt_sinai_trial_table, want_sign)

max_idx = max(existing_table.cluster_number) ;

centers = [];
for i = 1:max_idx
    cluster_table = existing_table(existing_table.cluster_number == i, :);
    x = mean(cluster_table.clusterX);
    y = mean(cluster_table.clusterY);
    z = mean(cluster_table.clusterZ);

    center = [x y z];
    centers = [centers; center];
end

mt_sinai_x = log(abs(mt_sinai_trial_table.x_coord)); 
mt_sinai_y = log(abs(mt_sinai_trial_table.y_coord));
mt_sinai_z = log(abs(mt_sinai_trial_table.z_coord));

if ~want_sign
    mt_sinai_x = mt_sinai_x .* sign(mt_sinai_trial_table.x_coord); 
    mt_sinai_y = mt_sinai_y .* sign(mt_sinai_trial_table.y_coord);
    mt_sinai_z = mt_sinai_z .* sign(mt_sinai_trial_table.z_coord);
end

xVsYVsZ = [mt_sinai_x, mt_sinai_y, mt_sinai_z];    

opt = fcmOptions(ClusterCenters = centers,NumClusters = size(centers,1));
[centers_determined_by_fcm,U] = fcm(xVsYVsZ,opt);

mpc = calculate_mpc(U);
maxU = max(U);

new_mt_sinai_cluster_table = [];
for j=1:size(centers,1)
    indexes = find(U(j,:)==maxU);

    idx_rows = mt_sinai_trial_table(indexes, :);
    idx_rows.cluster_idx = repelem(j,height(idx_rows),1);
    new_mt_sinai_cluster_table = [new_mt_sinai_cluster_table; idx_rows];

end


end