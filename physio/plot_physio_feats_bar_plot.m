function plot_physio_feats_bar_plot(merged_table,num_clusters,save_to,is_hr)

figure
l = [];
hs= [];
mean_bars = [];
std_errs = [];
for s = 1:num_clusters
    cluster_table = merged_table(merged_table.idx == s, :);

    if ~is_hr
        x = cluster_table.avg_eng;
    else
        x = cluster_table.percent_max_hr;
    end

    mean_x = mean(x, 'omitnan');

    std_x = std(x,'omitnan') / sqrt(sum(~isnan(x)));
    
    mean_bars = [mean_bars; mean_x];
    std_errs = [std_errs; std_x];
end


errorbar(1:num_clusters, mean_bars, std_errs)
hold off
xticklabels(1:num_clusters)
xlabel("clusters")

if ~is_hr
    ylabel('avg pupil diam')
    title('eye feats associated w clusters')

    subtitle_str = physio_clusters_anova(merged_table, num_clusters, is_hr);
    subtitle(subtitle_str)
    set(gcf,'renderer','Painters')
    savefig(save_to + 'eye_physio_feats_to_cluster_3d.fig')
else 
    ylabel('% max hr above avg')
    title('hr feats associated w clusters')

    subtitle_str = physio_clusters_anova(merged_table, num_clusters, is_hr);
    subtitle(subtitle_str)
    set(gcf,'renderer','Painters')
    savefig(save_to + 'hr_physio_feats_to_cluster_3d.fig')
end
end
