function plot_physio_feats_3d(merged_table,num_clusters,C,save_to,is_hr)

figure
l = [];
hs= [];
for s = 1:num_clusters
    cluster_table = merged_table(merged_table.idx == s, :);

    if ~is_hr
        x = cluster_table.nanmean_avg_eng;
        y = cluster_table.nanmean_num_maxes;
        z = cluster_table.nanmean_num_mins;
    else
        x = cluster_table.nanmean_percent_max_hr;
        y = cluster_table.nanmean_percent_min_hr;
        z = cluster_table.nanmean_direction;
    end

    mean_x = mean(x, 'omitnan');
    mean_y = mean(y,'omitnan');
    mean_z = mean(z,'omitnan');

    std_x = std(x,'omitnan') / sqrt(sum(~isnan(x)));
    std_y = std(y,'omitnan') / sqrt(sum(~isnan(y)));
    std_z = std(z,'omitnan') / sqrt(sum(~isnan(z)));

    h = scatter3(mean_x, mean_y, mean_z, 20, C{s}, 'filled');
    hold on
    plot3([mean_x,mean_x]', [mean_y,mean_y]', [-std_z,std_z]'+mean_z','Color',C{s})  
    hold on
    plot3([mean_x,mean_x]', [-std_y,std_y]'+mean_y', [mean_z,mean_z]','Color',C{s})  
    hold on
    plot3([-std_x,std_x]'+mean_x, [mean_y,mean_y]', [mean_z,mean_z]','Color',C{s})  
    hold on

    hs = [hs;h];
    curr_l = "cluster " + string(s);
    l = [l; curr_l];

end
hold off
legend(hs, l)
if ~is_hr
    xlabel('avg pupil diam')
    ylabel('num maxes in pupil diam')
    zlabel('num mins in pupil diam')
    title('eye feats associated w clusters')
    set(gcf,'renderer','Painters')
    savefig(save_to + 'eye_physio_feats_to_cluster_3d.fig')
else 
    xlabel('% max hr below avg')
    ylabel('% min hr below avg')
    zlabel('directoin')
    title('hr feats associated w clusters')
    set(gcf,'renderer','Painters')
    savefig(save_to + 'hr_physio_feats_to_cluster_3d.fig')
end
end
