function result_str = physio_clusters_anova(merged_table, num_clusters, is_hr, use_both)

xs = [];
ys = [];
zs = [];
ls = [];
for i = 1:num_clusters
    cluster_table = merged_table(merged_table.idx == i, :);
    ls = [ls; height(cluster_table)];

    if ~use_both
        if ~is_hr
            x = cluster_table.avg_eng;
            xs = [xs;x];
            feature = "avg pupil diameter";
        else
            x = cluster_table.percent_max_hr;
            xs = [xs;x];
            feature = "% above max HR";
        end

    else
         x = cluster_table.percent_max_hr;
         y = cluster_table.avg_eng;
         z = cluster_table.num_maxes;

        xs = [xs;x];
        ys = [ys; y];
        zs = [zs;z];
        feature = "% above max HR, avg eng, num spikes in eng";
    end

end

% Combine data
if use_both
    responseData = [xs; ys; zs]';
    num_feats = 3;
else
    responseData = [xs]';
    num_feats = 1;
end

% Create factor vectors
clusters = [];

for i = 1:num_feats
    for l = 1:length(ls)
        len = ls(l);
        clusters = [clusters repelem(l, len)];
    end
end

xfeat = repelem("max HR", length(xs),1);
yfeat = repelem("avg eng", length(ys),1);
zfeat = repelem("eng spikes", length(zs),1);
feats = [xfeat;yfeat;zfeat];



% Perform n-way ANOVA
if use_both
    [p,t,stats,terms] = anovan(responseData,{clusters;feats},'model','interaction','varnames',{'clusters','feats'});
else
     [p,t,stats,terms] = anovan(responseData,{clusters});
end   

if ~use_both
    result_str = "p-val of one-way anova: " + string(p(1)) +...
    " using " + feature + " over ";
else
    result_str = "p-val of three-way anova w/ interactions: " + string(p(1)) +...
    " using " + feature + " over ";
end
    

for c = 1:length(ls)
    result_str = result_str + newline + "cluster " +...
        string(c) + " trials, n = " + string(ls(c));
end
 
end