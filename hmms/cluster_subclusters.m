function cluster_subclusters(full_autoencoder_table, num_clusters)

%feature_triples{1} = ["auto_x", "auto_y", "auto_z"];
feature_triples{1} = ["auto_a", "auto_b", "auto_c"];
feature_triples{2} = ["auto_d", "auto_e", "auto_f"];


%{
feature_triples{2} = ["clusterX", "clusterY", "clusterZ"];
feature_triples{3} = ["a_R", "b_R", "b_C"];
feature_triples{4} = ["a_R", "a_C", "b_R"];
feature_triples{5} = ["a_R", "a_C", "b_R"];
%}

big_clusters = unique(full_autoencoder_table.auto_cluster);
for i = 1:length(big_clusters)
    sub_cluster = full_autoencoder_table(full_autoencoder_table.auto_cluster == i,:);

    for j = 1:length(feature_triples)
        features = feature_triples{j};

        feat_1 = sub_cluster.(features(1)) ;
        feat_2 = sub_cluster.(features(2)) ;
        feat_3 = sub_cluster.(features(3)) ;
        encoded3D = [feat_1 feat_2 feat_3];
    
        options = fcmOptions(NumClusters=num_clusters);
        [~, U] = fcm(encoded3D, options);
        [~, max_row_indices] = max(U);
        
        sub_cluster.new_sub_cluster = max_row_indices';
        
        figure
        scatter3(feat_1, feat_2, feat_3, 20, sub_cluster.new_sub_cluster)
        title("sub cluster " + i + " using features " + strjoin(features, ", "))
        xlabel(features(1))
        ylabel(features(2))
        zlabel(features(3))
    end

end
end