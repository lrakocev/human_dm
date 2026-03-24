function [all_means, all_stds] = plot_physio_feats_bar_plot(merged_table,feats,save_to)

l = [];
hs= [];
mean_bars = [];
std_errs = [];
num_clusters = max(merged_table.idx);

for f = 1:length(feats)
    feat = feats(f);
    bar_x = [];
    
    mean_bars = [];
    std_errs = [];
    for s = 1:num_clusters
        cluster_table = merged_table(merged_table.idx == s, :);
        
        if height(cluster_table) >= 5
            x = cluster_table.(feat);
            
            mean_x = mean(x, 'omitnan');
        
            std_x = std(x,'omitnan') / sqrt(sum(~isnan(x)));
            
            mean_bars = [mean_bars; mean_x];
            std_errs = [std_errs; std_x];
            bar_x = [bar_x; s];
        end
    end

    figure
    bar(bar_x, mean_bars)
    hold on
    errorbar(bar_x, mean_bars, std_errs)
    hold off
    xticklabels(1:num_clusters)
    xlabel("clusters")
    ylabel(feat)
    title(feat + " across clusters")
   % subtitle_str = physio_clusters_anova(merged_table, num_clusters, is_hr);
    set(gcf,'renderer','Painters')
    savefig(save_to + feat + "_across_clusters.fig")

end

end
