function feats_across_naive_binning(merged_table, bin_by, num_bins, feats, want_z)

xs = merged_table.(bin_by) ;

if ~want_z
    [binned_x, bins] = raw_binning_helper(xs, num_bins);
    merged_table.binned_x = binned_x;
    type_str = "(min-max)";
else 
    [binned_z, bins] =  z_binning_helper(xs, num_bins);
    merged_table.binned_x = binned_z;
    type_str = "(z-score)";
end

for f = 1:length(feats)
    feat = feats(f);

    mean_bars = [];
    std_errs = [];
    bar_x = [];
    for j = 1:num_bins
    
        bin_table = merged_table(merged_table.binned_x == j, :);

        subject_means = [];
        unique_ids = unique(bin_table.subjectidnumber);
        for k = 1:length(unique_ids)
            id = unique_ids(k);
            id_table = bin_table(bin_table.subjectidnumber == id, :);
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
   % bar(1:length(nonnan_bars), mean_bars(nonnan_bars))
    hold on
    errorbar(1:length(nonnan_bars), mean_bars(nonnan_bars), nonnan_serrs)
    hold off
    xlabel(bin_by + " " + type_str)
    xticklabels(bins)
    ylabel(feat)
    title(feat + " across groupings of " + bin_by)
   % subtitle_str = physio_clusters_anova(merged_table, num_clusters, is_hr);
    set(gcf,'renderer','Painters')
   % savefig(save_to + feat + "_across_clusters.fig")

end

end

function [output_bins, bins] = raw_binning_helper(input, num_bins)

max_val = max(input);
min_val = min(input);
interval = (max_val - min_val)/num_bins;
bins = min_val:interval:max_val;

output_bins = discretize(input,bins);

end

function [bin_zs, bins] = z_binning_helper(input, num_bins)

mean_val = mean(input, 'omitnan');
std_dev = std(input, [], 'omitnan');

output_zs = (input - mean_val) / std_dev; 

[bin_zs, bins] = raw_binning_helper(output_zs, num_bins);

end