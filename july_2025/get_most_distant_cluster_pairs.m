function [fin_table,dist_table] = get_most_distant_cluster_pairs(cluster_table)

cluster_table = readtable("all_clusters.xlsx");
fin_table = psychs_in_spec_cluster(cluster_table,1);

[group, ID] = findgroups(fin_table.idx);
meanX = splitapply(@mean, fin_table.clusterX, group);
meanY = splitapply(@mean, fin_table.clusterY, group);
meanZ = splitapply(@mean, fin_table.clusterZ, group);

coords = [meanX meanY meanZ];
all_pairs = nchoosek(1:15,2);

dist_table = [];
for i = 1:length(all_pairs)
    cluster1 = all_pairs(i,1);
    cluster2 = all_pairs(i,2);
    dist = norm(coords(cluster1,:) - coords(cluster2,:));
    row.cluster1 = cluster1;
    row.cluster2 = cluster2;
    row.dist = dist;
    dist_table = [dist_table; row];
end

dist_table = struct2table(dist_table);
dist_table = sortrows(dist_table, 'dist','descend');

end

