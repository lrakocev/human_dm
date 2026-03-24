function bootstrap_bars(merged_table, num_bins, feats)

num_rows = height(merged_table);
idx_list = 1:num_rows;
p = randperm(num_rows);

padding_needed = mod(-numel(p), num_bins); 
p_padded = [p(:); nan(padding_needed, 1)]

groups = reshape(p_padded, num_bins, []);

for f = 1:length(feats)
    feat = feats(f);

    mean_bars = [];
    std_errs = [];
    bar_x = [];

    for j = 1:num_bins
        group = groups(j,:)';
        group = group(~isnan(group));
        group_table = merged_table(group, :);

        subject_means = [];
        unique_ids = unique(group_table.subjectidnumber);
        for k = 1:length(unique_ids)
            id = unique_ids(k);
            id_table = group_table(group_table.subjectidnumber == id, :);
            vals = id_table.(feat);

            mean_subj_val = mean(vals, 'omitnan');
            subject_means = [subject_means; mean_subj_val];
        end

        mean_x = mean(subject_means, 'omitnan');
        std_x = std(subject_means,'omitnan') / sqrt(sum(~isnan(subject_means)));
        
        mean_bars = [mean_bars; mean_x];
        std_errs = [std_errs; std_x];
        bar_x = [bar_x; j];   

    end

    nonnan_bars = find(~isnan(mean_bars));
    nonnan_serrs = std_errs(nonnan_bars);
    figure
    bar(1:length(nonnan_bars), mean_bars(nonnan_bars))
    hold on
    errorbar(1:length(nonnan_bars), mean_bars(nonnan_bars), nonnan_serrs)
    hold off
    xlabel("random groupings")
    ylabel(feat)
    title(feat + " across random groupings")
    set(gcf,'renderer','Painters')
   % savefig(save_to + feat + "_across_clusters.fig")
end


end