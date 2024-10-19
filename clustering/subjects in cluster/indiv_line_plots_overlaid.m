function indiv_line_plots_overlaid(all_psych_data, story_type, save_to)

all_psych_data = all_psych_data(all_psych_data.experiment == story_type, :);

num_clusters = max(unique(all_psych_data.idx));
unique_ids = unique(all_psych_data.subjectidnumber);
cluster_stats = cell(1,num_clusters);
figure
for i = 1:length(unique_ids)
    id = unique_ids(i);
    curr_table = all_psych_data(all_psych_data.subjectidnumber == id, :);
    tot_num = height(curr_table);
    clusters = curr_table.idx;
    [gc,gr] = groupcounts(clusters);
    sum_gc = sum(gc);
    gc = gc / sum_gc;
    for n = 1:length(gr)
        cluster = gr(n);
        stat = gc(n);
        cluster_stats{cluster} = [cluster_stats{cluster} ; stat];
    end

    plot(gr,gc)
    hold on
   
end

xlabel('cluster number')
ylabel('percentage')
title("distribution of individuals pts across " + story_type + " clusters")
subtitle("n = " + string(length(unique_ids)) + " individuals")

set(gcf,'renderer','Painters')
savefig(save_to + story_type +".fig")
saveas(gcf, save_to + story_type, "svg")
close all


end