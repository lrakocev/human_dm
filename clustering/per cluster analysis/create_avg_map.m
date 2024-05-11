function create_avg_map(sesh_data, psych_to_cluster, type, want_scale, save_to, split_by_dim, use_cost)

clusters = unique(psych_to_cluster.idx);
num_clusters = length(clusters);

%ax = zeros(num_clusters,1);
if split_by_dim
    f0 = figure(1);
    f1 = figure(2);
    f2 = figure(3);
else
    f3 = figure(4);
end
for i = 1 : num_clusters
    cluster = clusters(i);
    sesh_info = psych_to_cluster(psych_to_cluster.idx == cluster, :);

    if use_cost 
         merge = outerjoin(sesh_info,sesh_data,'Keys',{'cost','story_num','subjectidnumber'},'MergeKeys',1);
    else 
        merge = outerjoin(sesh_info,sesh_data,'Keys',{'story_num','subjectidnumber'},'MergeKeys',1);
    end
    sesh_table = merge(~isnan(merge.idx),:);

    combined_data = combine_for_map({sesh_table}, '');
    map_table = combined_data{1};

    dim = get_map_dim(map_table, 5);
    if split_by_dim
        figure(dim+1)
    else
        figure(4)
    end
    nexttile
    make_dec_making_plots(map_table,"","",1,want_scale,0)
    title("cluster " + string(i) + " dim: " + string(dim))
end
if want_scale 
    figname = save_to + "/" + strrep(type," ", "_") + "_rel_scale";
else 
    figname = save_to + "/" + strrep(type," ", "_");
end
sgtitle("average dec map for " + type)
if split_by_dim
    saveas(f0, figname + "_dim_0.fig")
    saveas(f1, figname + "_dim_1.fig")
    saveas(f2, figname + "_dim_2.fig")
else
    saveas(f3, figname + ".fig")
end
close all 

end