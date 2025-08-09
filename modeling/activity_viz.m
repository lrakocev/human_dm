function activity_viz(triplets,max_activity,save_to)

dims = unique(triplets.dim);

for i = 1:length(dims)
    d = dims(i);
    dim_subset = triplets(triplets.dim == d, :);
    ordered_dim = sortrows(dim_subset,'prob','descend');
    figure
    for j = 1:height(ordered_dim)
        nexttile
        strio = ordered_dim.strio(j);
        lh = ordered_dim.lh(j);
        da = ordered_dim.da(j);
        prob = ordered_dim.prob(j);
        bars = [strio lh da];
        bars = bars / max_activity;
        b = bar([1 2 3], bars,'FaceColor','flat');
        b.CData(2,:) = [0 1 0];
        b.CData(3,:) = [1 0 0];
        xticklabels({"strio","lh","da"})
        ylabel("activity level")
        title("probability of config: " + string(prob))
    end
    sgtitle("configs for maps with dim=" + string(d))
    savefig(save_to + "\dim_" + string(d) + ".fig")
    close all
end


 
end
