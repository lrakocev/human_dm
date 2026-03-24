function plot_physio_spider_plot(merged_table, mt_sinai_table, eye_features, hr_features, hormone_features, titstr)

hr_table = merged_table(~isnan(merged_table.mean_hr), :);
eye_table = merged_table(~isnan(merged_table.pupil_diameter), :);

num_clusters = max(merged_table.idx);
figure
all_cluster_means = [];
all_cluster_serrs = {};
for i = 1:num_clusters
    eye_cluster_table = eye_table(eye_table.idx == i, :);
    hr_cluster_table = hr_table(hr_table.idx == i, :);
    mt_sinai_cluster_table = mt_sinai_table(mt_sinai_table.cluster_idx == i, :);

    curr_cluster_means = [];
    curr_cluster_serrs = [];
    for j = 1:length(eye_features)
        eye_feat_name = eye_features(j);
        eye_feat_list = eye_cluster_table.(eye_feat_name);
        mean_eye_feat = mean(eye_feat_list,'omitnan');
        mean_eye_serr = std(eye_feat_list,'omitnan') / sqrt(sum(~isnan(eye_feat_list)));
        curr_cluster_means = [curr_cluster_means mean_eye_feat];
        curr_cluster_serrs = [curr_cluster_serrs mean_eye_serr];
    end

    for k = 1:length(hr_features)
            hr_feat_name = hr_features(k);
            hr_feat_list = hr_cluster_table.(hr_feat_name);
            mean_hr_feat = mean(hr_feat_list,'omitnan');
            mean_hr_serr = std(hr_feat_list,'omitnan') / sqrt(sum(~isnan(hr_feat_list)));
            curr_cluster_means = [curr_cluster_means mean_hr_feat];
            curr_cluster_serrs = [curr_cluster_serrs mean_hr_serr];
        end
    

     for l = 1:length(hormone_features)
        hormone_feat_name = hormone_features(l);
        hor_feat_list = mt_sinai_cluster_table.(hormone_feat_name);
        mean_hor_feat = mean(hor_feat_list,'omitnan');
        mean_hor_serr = std(hor_feat_list,'omitnan') / sqrt(sum(~isnan(hor_feat_list)));
        curr_cluster_means = [curr_cluster_means mean_hor_feat];
        curr_cluster_serrs = [curr_cluster_serrs mean_hor_serr];

    end

    all_cluster_means = [all_cluster_means; curr_cluster_means];
    all_cluster_serrs{i} = curr_cluster_serrs;

end

all_features = [eye_features hr_features hormone_features];

spider_plot(all_cluster_means,...
    'AxesLabels', cellstr(all_features),...
    'AxesShaded', 'on',...
    'Color',distinguishable_colors(num_clusters),...
    'AxesShadedTransparency', 0.1);

hold on
legend(string(1:num_clusters))
title("physio feats across clusters for clustering type: " + titstr)

end