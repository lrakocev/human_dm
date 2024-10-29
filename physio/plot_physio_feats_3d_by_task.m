function plot_physio_feats_3d_by_task(merged_table,story_types,C,save_to,is_hr,use_all)

figure
l = [];
hs= [];
mean_bars = [];
std_errs = [];
for s = 1:length(story_types)
    story = story_types(s);
    cluster_table = merged_table(merged_table.experiment == story, :);

    if ~is_hr
        x = cluster_table.avg_eng;
        y = cluster_table.num_maxes / cluster_table.order;
        z = cluster_table.num_mins  / cluster_table.order;
    else
        x = cluster_table.percent_max_hr;
        y = cluster_table.percent_min_hr;
        z = cluster_table.direction;
    end

    mean_x = mean(x, 'omitnan');
    mean_y = mean(y,'omitnan');
    mean_z = mean(z,'omitnan');

    std_x = std(x,'omitnan') / sqrt(sum(~isnan(x)));
    std_y = std(y,'omitnan') / sqrt(sum(~isnan(y)));
    std_z = std(z,'omitnan') / sqrt(sum(~isnan(z)));

    if use_all 
        h = scatter3(mean_x, mean_y, mean_z, 20, C{s}, 'filled');
        hold on
        plot3([mean_x,mean_x]', [mean_y,mean_y]', [-std_z,std_z]'+mean_z','Color',C{s})  
        hold on
        plot3([mean_x,mean_x]', [-std_y,std_y]'+mean_y', [mean_z,mean_z]','Color',C{s})  
        hold on
        plot3([-std_x,std_x]'+mean_x, [mean_y,mean_y]', [mean_z,mean_z]','Color',C{s})  
        hold on
    
        hs = [hs;h];
        l = [l; story];
    else
        mean_bars = [mean_bars; mean_x];
        std_errs = [std_errs; std_x];
    end

end
if use_all
    hold off
    legend(hs, l)
else
    errorbar([1 2 3 4], mean_bars,std_errs)
    hold off
    
end


if ~is_hr
    xlabel('avg pupil diam')
    ylabel('num maxes in pupil diam')
    zlabel('num mins in pupil diam')
    title('eye feats associated w tasks')

    subtitle_str = physio_tasks_anova(merged_table, story_types, is_hr, use_all);
    subtitle(subtitle_str)
    set(gcf,'renderer','Painters')
    savefig(save_to + 'eye_physio_feats_to_task_3d.fig')
else 
    if use_all
        xlabel('% max hr above avg')
        ylabel('% min hr below avg')
        zlabel('direction')
    else
        xlabel('clusters')
        xticklabels(story_types)
        ylabel('% max hr above avg')
    end
    title('hr feats associated w tasks')

    subtitle_str = physio_tasks_anova(merged_table, story_types, is_hr, use_all);
    subtitle(subtitle_str)
    set(gcf,'renderer','Painters')
    savefig(save_to + 'hr_physio_feats_to_task_3d.fig')
end
end
