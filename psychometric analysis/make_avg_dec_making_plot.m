function avg_data = make_avg_dec_making_plot(data, story_types, path_to_save,want_bdry,want_scale,want_save)

avg_data = cell(1,4);

for i = 1:length(story_types)
    combined_data = data{i};
    story_type = story_types{i};
    tot_table = [];
    for N = 1:length(combined_data)
        curr_data = combined_data{N};
        if ~isempty(curr_data)
            tot_table = [tot_table; curr_data];
        end
    end
    avg_table = [];
    for r = 1:4
        for c = 1:4
            all_r_c = tot_table(tot_table.rew == r & tot_table.cost == c, :);
            r_c_row = all_r_c(1,:);
            r_c_row.subjectidnumber = "scaled avg";
            r_c_row.approach_rate = mean(all_r_c.approach_rate, 'omitnan');
            avg_table = [avg_table; r_c_row];
        end
    end
    avg_data{i} = avg_table;
    make_dec_making_plots(avg_table, path_to_save, story_type,want_bdry,want_scale,want_save)
end

end