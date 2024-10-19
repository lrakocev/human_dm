function create_avg_map(sesh_data, psych_to_cluster, type, want_scale, save_to, use_cost)

clusters = unique(psych_to_cluster.idx);
num_clusters = length(clusters);

%ax = zeros(num_clusters,1);
figure
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

    nexttile
    make_dec_making_plots(map_table,"","",1,want_scale,0,"")
    title("cluster " + string(i))
end
if want_scale 
    figname = save_to + "/" + strrep(type," ", "_") + "_rel_scale";
else 
    figname = save_to + "/" + strrep(type," ", "_");
end
sgtitle("average dec map for " + type)

set(gcf,'renderer','Painters')
saveas(gcf, figname, "svg")
saveas(gcf, figname + ".fig")

close all 

end