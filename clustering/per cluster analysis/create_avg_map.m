function create_avg_map(sesh_data, psych_to_cluster, type, want_scale, save_to)

clusters = unique(psych_to_cluster.idx);
num_clusters = length(clusters);

ax = zeros(num_clusters,1);
for i = 1 : num_clusters
    cluster = clusters(i);
    sesh_info = psych_to_cluster(psych_to_cluster.idx == cluster, :);

    merge = outerjoin(sesh_info,sesh_data,'Keys',{'cost','story_num','subjectidnumber'},'MergeKeys',1);
    sesh_table = merge(~isnan(merge.idx),:);

    combined_data = combine_for_map({sesh_table}, '');

    ax(i) = subplot(3,3,i);
    make_dec_making_plots(combined_data{1},"","",0,want_scale,0)
    title("cluster " + string(i))

end
if want_scale 
    figname = save_to + "/" + strrep(type," ", "_") + "_rel_scale.fig";
else 
    figname = save_to + "/" + strrep(type," ", "_") + ".fig";
end
sgtitle("average dec map for " + type)
savefig(figname)
close all 
end