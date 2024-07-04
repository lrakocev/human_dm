function result_str = physio_clusters_anova(merged_table, num_clusters, is_hr)

xs = [];
ls = [];
for i = 1:num_clusters
    cluster_table = merged_table(merged_table.idx == i, :);
    ls = [ls; height(cluster_table)];

    if ~is_hr
        x = cluster_table.avg_eng;

        xs = [xs;x];
        feature = "avg pupil diameter";
        
    else
        x = cluster_table.percent_max_hr;

        xs = [xs;x];
        feature = "% above max HR";
    end
end

% Combine data
responseData = [xs]';

% Create factor vectors
clusters = [];
for l = 1:length(ls)
    len = ls(l);
    clusters = [clusters repelem(l, len)];
end

% Perform n-way ANOVA
[p,t,stats,terms] = anovan(responseData,{clusters});

result_str = "p-val of one-way anova: " + string(p(1)) +...
    " using " + feature + " over ";
for c = 1:length(ls)
    result_str = result_str + newline + "cluster " +...
        string(c) + " trials, n = " + string(ls(c));
end
end