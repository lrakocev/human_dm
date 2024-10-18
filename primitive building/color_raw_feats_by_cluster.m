function num_pts = color_raw_feats_by_cluster(feat_table)

clusters = unique(feat_table.cluster_number);
colors = distinguishable_colors(length(clusters));

num_pts = 0;
hs = [];
figure
for i = 1:height(clusters)
    cluster = clusters(i);
    col = colors(i,:);
    cluster_table = feat_table(feat_table.cluster_number == cluster, :);
    num_pts = num_pts + height(cluster_table);

    x = log(cluster_table.med_appr);
    y = log(cluster_table.c_interact);
    z = log(cluster_table.subj_var);

    h =  scatter3(x,y,z,[],col);
    hs = [hs; h];
    hold on
end

xlabel('med appr')
ylabel('c interact')
zlabel('subj var')
legend(hs)
title('raw feats colored by param cluster')
hold off
end