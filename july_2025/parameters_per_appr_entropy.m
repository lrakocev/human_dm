function appr_entropy_table = parameters_per_appr_entropy(merged_table,num_bins,measure)

measure_data = merged_table.(measure);

measure_max = max(measure_data);
measure_min = min(measure_data);

interval = (measure_max - measure_min) / num_bins;
measure_lvls = measure_min:interval:measure_max;

all_rows = [];
for i = 2:length(measure_lvls)
    bottom = measure_lvls(i-1);
    top = measure_lvls(i);
    measure_table = merged_table(merged_table.(measure) < top & ...
        merged_table.(measure) >= bottom, :);

    if ~isempty(measure_table)
        curr_row.(measure+"_lvl") = mean([bottom, top]);
    
        appr_data = measure_table.approach_rate;
        curr_row.appr_mean = mean(appr_data,'omitnan');
        curr_row.appr_entropy = calc_entropy(appr_data);
        curr_row.appr_variance = var(appr_data,'omitnan');
        curr_row.rew = mean(measure_table.rew);
        curr_row.cost = mean(measure_table.cost);
    
        all_rows = [all_rows; curr_row];
    end

end
if ~isempty(all_rows)
    appr_entropy_table = struct2table(all_rows);
else
    appr_entropy_table = [];
end

end
