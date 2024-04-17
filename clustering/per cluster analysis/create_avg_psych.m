function create_avg_psych(sesh_data, psych_to_cluster, type, same_scale, save_to)

clusters = unique(psych_to_cluster.idx);
num_clusters = length(clusters);

ax = zeros(num_clusters,1);
y_min = 100;
y_max = 0;
for i = 1 : num_clusters
    cluster = clusters(i);
    sesh_info = psych_to_cluster(psych_to_cluster.idx == cluster, :);

    merge = outerjoin(sesh_info,sesh_data,'Keys',{'cost','story_num','subjectidnumber'},'MergeKeys',1);
    sesh_table = merge(~isnan(merge.idx),:);

    lvl_1 = sesh_table(sesh_table.rew == 1, :).approach_rate;
    lvl_2 = sesh_table(sesh_table.rew == 2, :).approach_rate;
    lvl_3 = sesh_table(sesh_table.rew == 3, :).approach_rate;
    lvl_4 = sesh_table(sesh_table.rew == 4, :).approach_rate;

    mean_lvl_1 = mean(lvl_1, 'omitnan');
    mean_lvl_2 = mean(lvl_2, 'omitnan');
    mean_lvl_3 = mean(lvl_3, 'omitnan');
    mean_lvl_4 = mean(lvl_4, 'omitnan');

    x = [1,2,3,4];
    y = [mean_lvl_1, mean_lvl_2, mean_lvl_3, mean_lvl_4];

    ax(i) = subplot(1,num_clusters,i);
    fit_sigmoid(x,y);
    yl = get(gca, 'YLim');
    curr_y_min = yl(1);
    curr_y_max = yl(2);
    if curr_y_min < y_min 
        y_min = curr_y_min;
    end
    if curr_y_max > y_max
        y_max = curr_y_max;
    end
    title("cluster " + string(i))

end
figname = save_to + "/" + strrep(type," ", "_") + ".fig";
if same_scale
    set(ax, 'YLim', [y_min y_max])
    figname = save_to + "/" + strrep(type," ", "_") + "_same_scale.fig";
end
sgtitle("average sigmoid per cluster for " + type)
savefig(figname)
close all 
end