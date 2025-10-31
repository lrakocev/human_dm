function mpc = try_clustering_hmm_states(all_hmm_states_table, num_clusters, clustered_feats, graphed_feats, omit_missing)

all_hmm_states_table = all_hmm_states_table(:, clustered_feats);

if omit_missing
    all_hmm_states_table = all_hmm_states_table(~isnan(all_hmm_states_table.pupil_diameter), :);
else
   all_hmm_states_table = all_hmm_states_table(:, {'approach_rate', 'rew', 'cost'});
end

state_arr = table2array(all_hmm_states_table);
opt = fcmOptions(NumClusters = num_clusters);
[centers_determined_by_fcm,U,~,info] = fcm(state_arr,opt);

mpc = calculate_mpc(U);
maxU = max(U);

colors = distinguishable_colors(num_clusters);

figure;
scatters = [];
for j=1:num_clusters
    current_color = colors(j,:);
    indexes = find(U(j,:)==maxU);

    idx_rows = all_hmm_states_table(indexes, :);
    scatter_object = scatter3(idx_rows.(graphed_feats(1)),idx_rows.(graphed_feats(2)), idx_rows.(graphed_feats(3)), [],current_color);
    hold on
end

legend(scatters,string(1:num_clusters)); 
xlabel(graphed_feats(1));
ylabel(graphed_feats(2));
zlabel(graphed_feats(3))
title("clustering for hmm states, mpc = " + string(mpc) + ", num clusters = " + string(num_clusters))

end
