function appr_lvl_table = parameters_per_appr_lvl(merged_table,k)

appr_lvls = 0:k:100;

all_rows = [];
for i = 2:length(appr_lvls)

    bottom = appr_lvls(i-1);
    top = appr_lvls(i);
    appr_lvl_table = merged_table(merged_table.approach_rate < top & ...
        merged_table.approach_rate >= bottom, :);
    
    curr_row.appr_lvl_bottom = bottom;
    curr_row.appr_lvl_top = top;

    measures = ["pupil_diameter", "heart_rate", "pain", "hunger", "tiredness", "story_prefs", "cost", "rew"];

    for j = 1:length(measures)
        measure = measures(j);
        
        measure_data = appr_lvl_table.(measure);

        curr_row.(measure+"_mean") = mean(measure_data,'omitnan');
        curr_row.(measure+"_entropy") = calc_entropy(measure_data);
        curr_row.(measure+"_variance") = var(measure_data,'omitnan');
        %curr_row.(measure+"_sensitivity") = calc_sensitivity(measure_data);
        
    end

    all_rows = [all_rows; curr_row];
    
end

appr_lvl_table = struct2table(all_rows);
end
