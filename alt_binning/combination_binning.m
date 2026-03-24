function combination_binning(merged_table, bin_by, num_bins, feats, want_z)

xs = merged_table.(bin_by(1)) ;
ys = merged_table.(bin_by(2)) ;
zs = merged_table.(bin_by(3)) ;

if ~want_z
    merged_table.binned_x = raw_binning_helper(xs, num_bins);
    merged_table.binned_y = raw_binning_helper(ys, num_bins);
    merged_table.binned_z = raw_binning_helper(zs, num_bins);
    type_str = "(min-max)";
else 
    merged_table.binned_x = z_binning_helper(xs, num_bins);
    merged_table.binned_y = z_binning_helper(ys, num_bins);
    merged_table.binned_z = z_binning_helper(zs, num_bins);

    type_str = "(z-score)";

end


all_combos = combinations(1:num_bins, 1:num_bins, 1:num_bins);

for f = 1:length(feats)
    feat = feats(f);

    mean_bars = [];
    std_errs = [];
    bar_x = [];
    combo_names = [];
    for j = 1:height(all_combos)
        combo = all_combos(j,:);
        x = combo.Var1;
        y = combo.Var2;
        z = combo.Var3;
    
        fitting_combo = merged_table(merged_table.binned_x == x & ...
            merged_table.binned_y == y & merged_table.binned_z == z, :);

        subject_means = [];
        unique_ids = unique(fitting_combo.subjectidnumber);
        for k = 1:length(unique_ids)
            id = unique_ids(k);
            id_table = fitting_combo(fitting_combo.subjectidnumber == id, :);
            vals = id_table.(feat);

            mean_subj_val = mean(vals, 'omitnan');
            subject_means = [subject_means; mean_subj_val];
        end

        mean_x = mean(subject_means, 'omitnan');
    
        std_x = std(subject_means,'omitnan') / sqrt(sum(~isnan(subject_means)));
        
        mean_bars = [mean_bars; mean_x];
        std_errs = [std_errs; std_x];
        bar_x = [bar_x; j];
        combo_names = [combo_names; string(x + ", " + y + ", " + z)];
    
    end


    nonnan_bars = find(~isnan(mean_bars));
    nonnan_serrs = std_errs(nonnan_bars);
    nonnan_combos = combo_names(nonnan_bars, :);
    figure
    bar(1:length(nonnan_bars), mean_bars(nonnan_bars))
    hold on
    errorbar(1:length(nonnan_bars), mean_bars(nonnan_bars), nonnan_serrs)
    hold off
    xlabel("naive groupings (combos of bins for each var) " + type_str)
    xticklabels(nonnan_combos)
    ylabel(feat)
    title(feat + " across groupings of " + bin_by)
   % subtitle_str = physio_clusters_anova(merged_table, num_clusters, is_hr);
    set(gcf,'renderer','Painters')
   % savefig(save_to + feat + "_across_clusters.fig")

end

end


function [output_bins] = raw_binning_helper(input, num_bins)

max_val = max(input);
min_val = min(input);
interval = (max_val - min_val)/num_bins;
bins = min_val:interval:max_val;

output_bins = discretize(input,bins);

end

function [bin_zs] = z_binning_helper(input, num_bins)

mean_val = mean(input, 'omitnan');
std_dev = std(input, [], 'omitnan');

output_zs = (input - mean_val) / std_dev; 

[bin_zs] = raw_binning_helper(output_zs, num_bins);

end