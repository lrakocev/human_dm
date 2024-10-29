function means = prim_histogram(prim_table, hum_or_rat, feat_name, want_save, save_to)

% to get the unique table w/o repeats (for each trial, since each session 
% has 16 trials) only grab r=1, c=1

prim_table = prim_table(prim_table.rew == 1 & prim_table.cost == 1, :);

means = [];
serrs = [];
anova = [];
ls = [];
clusters = unique(prim_table.idx);
for i = 1:length(clusters)
    cluster = clusters(i);
    cluster_table = prim_table(prim_table.idx == cluster, :);

    if feat_name == "mean appr"
        data = cluster_table.mean_appr;
    elseif feat_name == "max appr"
        data = cluster_table.max_appr;
    elseif feat_name == "min appr"
        data = cluster_table.min_appr;
    elseif feat_name == "mse"
        data = cluster_table.mse;
    elseif feat_name == "valuation"
        data = cluster_table.clusterY;
    elseif feat_name == "elasticity"
        data = cluster_table.clusterZ;
    elseif feat_name == "raw valuation"
        data = cluster_table.rawY;
    elseif feat_name == "raw elasticity"
        data = cluster_table.rawZ;
    elseif feat_name == "reward impulse"
        data = cluster_table.r_impulse;
    elseif feat_name == "cost impulse"
        data = cluster_table.c_impulse;
    elseif feat_name == "reward interact"
        data = cluster_table.r_interact;
    elseif feat_name == "cost interact"
        data = cluster_table.c_interact;
    elseif feat_name == "subj var"
        data = cluster_table.subj_var;
    elseif feat_name == "sesh var"
        data = cluster_table.sesh_var;
    elseif feat_name == "indiv var from cluster mean"
        data = cluster_table.cluster_mse;
    end

    anova = [anova; data];
    ls = [ls; height(data)];
    [curr_mean, curr_serr] = get_summary(data);
    
    means = [means; curr_mean];
    serrs = [serrs; curr_serr];


end

if feat_name == "valuation"
    feat_name = "valuation (aka shift)";
elseif feat_name == "elasticity"
    feat_name = "elasticity (aka slope)";
end

cls = cumsum(ls);

if feat_name == "indiv var from cluster mean" || feat_name == "subj var"
    ftest = 1;
    % checking diff for cluster 5
    [h1,p1] = vartest2(anova(1:cls(1)), anova(cls(2):cls(3)));
    [h2,p2] = vartest2(anova(cls(1):cls(2)), anova(cls(2):cls(3)));
    [h3,p3] = vartest2(anova(cls(3):cls(4)),  anova(cls(2):cls(3)));
    [h4,p4] = vartest2(anova(cls(4):cls(5)),  anova(cls(2):cls(3)));

    p = strjoin([string(p1),string(p2),string(p3),string(p4)]," ");
elseif feat_name == "sesh var"
    ftest = 1;
    [h1,p1] = vartest2(anova(1:cls(1)), anova(cls(4):cls(5)));
    [h2,p2] = vartest2(anova(cls(1):cls(2)), anova(cls(4):cls(5)));
    [h3,p3] = vartest2(anova(cls(2):cls(3)), anova(cls(4):cls(5)));
    [h4,p4] = vartest2(anova(cls(3):cls(4)),  anova(cls(4):cls(5)));

    p = strjoin([string(p1),string(p2),string(p3),string(p4)]," ");
else
    ftest = 0;
    p = calc_anova(anova, ls);
end

plot_data(clusters,means, serrs, hum_or_rat + " " + feat_name, p, ftest, want_save, save_to)

end

function [means, serrs] = get_summary(data)

non_nan = data(~isnan(data));
means = mean(non_nan, 'omitnan');
serrs = std(non_nan, 'omitnan') / sqrt(length(non_nan));

end

function p = calc_anova(data, ls)

clusters = [];
for l = 1:length(ls)
    len = ls(l);
    clusters = [clusters repelem(l, len)];
end

[p,t,stats,terms] = anovan(data,{clusters});

end

function plot_data(unique_clusters,mean_dat, serr_dat, feat_name, p, ftest, want_save, save_to)

figure
bar(unique_clusters,mean_dat)
hold on
if ~ftest
    errorbar(unique_clusters,mean_dat, serr_dat)
end
xlabel("cluster number")
ylabel(feat_name)
title(feat_name + " for psychs in cluster, one-way anova p=" + string(p))
if want_save
    set(gcf,'renderer','Painters')
    saveas(gcf,save_to + "\" + feat_name, "fig")
    saveas(gcf,save_to + "\" + feat_name, "svg")
end

end