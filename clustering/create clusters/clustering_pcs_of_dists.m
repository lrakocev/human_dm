function [clustering_output, avg_diff_per_cluster] = clustering_pcs_of_dists(distances, cluster_diffs, num_clusters)

non_nan_distances = distances(~sum(isnan(distances),2),:);
pc_matrix = pca(non_nan_distances');

same_cluster = cluster_diffs(:,1) == 0;

colors = zeros(length(same_cluster), 3);
colors(same_cluster==1, :) = repmat([1 0 0], sum(same_cluster==1), 1);
colors(same_cluster==0, :) = repmat([0 0 1], sum(same_cluster==0), 1); 

figure
scatter3(pc_matrix(:,1),pc_matrix(:,2),pc_matrix(:,3),30,colors)

[index,V,D] = spectralcluster(pc_matrix,num_clusters,'Distance','euclidean');
unique_indexes = unique(index);
disp("V")
disp(V);
disp("D")
disp(D);

clustering_output = [non_nan_distances pc_matrix index same_cluster cluster_diffs(:,2:3)];

num_dists = size(non_nan_distances, 2);
num_pcs = size(pc_matrix,2);
dist_names = "dist_" + [1:num_dists];
pc_names = "pc_" + [1:num_pcs];
var_names = [dist_names pc_names  "cluster_idx" "pts_in_same_cluster" "c1" "c2"];
clustering_output = array2table(clustering_output, "VariableNames", var_names);

colors = distinguishable_colors(num_clusters);
figure;
scats = [];
avg_diff_per_cluster = [];
for j=1:length(unique_indexes)
    current_color = colors(j,:);
    group_n = pc_matrix(index==unique_indexes(j),:);

    avg_diff = mean(sum(abs(group_n),2));
    row.cluster_idx = j;
    row.avg_diff = avg_diff;
    avg_diff_per_cluster = [avg_diff_per_cluster; row];
    scatter_object = scatter3(group_n(:,1),group_n(:,2),group_n(:,3),[],current_color);
    scats = [scats;scatter_object];
    hold on
end
avg_diff_per_cluster = struct2table(avg_diff_per_cluster);

legend(scats, string(1:num_clusters))
xlabel("pca 1")
ylabel("pca 2")
zlabel("pca 3")

end