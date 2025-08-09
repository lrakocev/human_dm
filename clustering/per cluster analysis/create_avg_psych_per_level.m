function create_avg_psych_per_level(sesh_data, psych_to_cluster, type, save_to, use_cost)

clusters = unique(psych_to_cluster.idx);
num_clusters = length(clusters);

ax_rew = zeros(num_clusters,1);
ax_cost = zeros(num_clusters,1);
y_min = 100;
y_max = 0;
colors = ["r";"b";"g";"y"];
for i = 1 : num_clusters
    cluster = clusters(i);
    sesh_info = psych_to_cluster(psych_to_cluster.idx == cluster, :);

    if use_cost
        merge = outerjoin(sesh_info,sesh_data,'Keys',{'cost','story_num','subjectidnumber'},'MergeKeys',1);
    else
        merge = outerjoin(sesh_info,sesh_data,'Keys',{'story_num','subjectidnumber'},'MergeKeys',1);
    end
    sesh_table = merge(~isnan(merge.idx),:);

    figure(1)
    for r = 1:4
        r_table = sesh_table(sesh_table.rew == r, :);
        r_lvl_appr = [];
        for c = 1:4
            c_table = r_table(r_table.cost == c, :);
            mean_appr = mean(c_table.approach_rate, 'omitnan');
            r_lvl_appr = [r_lvl_appr; mean_appr];
        end
        x = [1 2 3 4];
        ax_rew(i) = subplot(1,num_clusters,i);
        fit_sigmoid(x,r_lvl_appr',colors(r));
        hold on
    end
    lgd = findobj('type', 'legend');
    delete(lgd)
    title("cluster " + string(i))
    hold off

    figure(2)
    for c = 1:4
        c_table = sesh_table(sesh_table.cost == c, :);
        c_lvl_appr = [];
        for r = 1:4
            r_table = c_table(c_table.rew == r, :);
            mean_appr = mean(r_table.approach_rate, 'omitnan');
            c_lvl_appr = [c_lvl_appr; mean_appr];
        end
        x = [1 2 3 4];
        ax_cost(i) = subplot(1,num_clusters,i);
        fit_sigmoid(x,c_lvl_appr',colors(c));
        hold on
    end
    lgd = findobj('type', 'legend');
    delete(lgd)
    title("cluster " + string(i))
    hold off

end
figure(1)
sgtitle("average sigmoid per cluster for each reward lvl across " + type + " stories")
figure(2)
sgtitle("average sigmoid per cluster for each cost lvl across " + type + " stories")

saveas(figure(1),save_to +"/"+ type + "_avg_sigmoid_reward_lvls.fig")
saveas(figure(2),save_to +"/"+ type + "_avg_sigmoid_cost_lvls.fig")
close all
end
