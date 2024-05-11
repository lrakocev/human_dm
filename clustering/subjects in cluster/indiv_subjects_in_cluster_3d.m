function indiv_subjects_in_cluster_3d(all_psych_data, story_type, save_to)

all_psych_data = all_psych_data(all_psych_data.story_type == story_type, :);

num_clusters = max(unique(all_psych_data.idx));
unique_ids = unique(all_psych_data.subjectidnumber);
cluster_stats = cell(1,num_clusters);
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

    figure
    bar(gr,gc)
    xlabel('cluster number')
    ylabel('percentage')
    title("distribution of " + string(id) + "'s pts across " + story_type + " cluster")
    subtitle("across " + string(tot_num) + " sessions")

    savefig(save_to + string(id)+".fig")
    close all
end

end