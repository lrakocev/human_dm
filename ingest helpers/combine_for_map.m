function combined_data = combine_for_map(approach_data, story_type)

combined_data = cell(1,length(approach_data));
for N = 1:length(approach_data)
    appr_table = approach_data{N};
    combined_table = [];
    for r = 1:4
        for c = 1:4
            if story_type ~= ""
                all_r_c = appr_table(appr_table.rew == r & appr_table.cost == c & appr_table.story_type == story_type, :);
            else
                all_r_c = appr_table(appr_table.rew == r & appr_table.cost == c, :);
            end
            if ~isempty(all_r_c)
                all_r_c.timing(all_r_c.timing==-1) = nan;
                all_r_c.approach_rate(isnan(all_r_c.timing)) = nan;
                r_c_row = all_r_c(1,:);
                r_c_row.approach_rate = mean(all_r_c.approach_rate, 'omitnan');
                r_c_row.timing = mean(all_r_c.timing, 'omitnan');
                combined_table = [combined_table; r_c_row];
            end
        end
    end
    combined_data{N} = combined_table;
end

end