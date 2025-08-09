function summary_table = create_summary_table(all_psych_data,total_table,tasks)

num_clusters = max(all_psych_data.idx);
summary_table = [];
for t1 = 1:length(tasks)
    task1 = tasks(t1);
    for t2 = 1:length(tasks)
        task2 = tasks(t2);
        for c1 = 1:num_clusters
            ys = [];
            y_errs = [];
            for c2 = 1:num_clusters
                c_table = total_table(total_table.task1 == task1 & total_table.task2 == task2 & ...
                    total_table.c1 == c1 & total_table.c2 == c2, :);
                if ~isempty(c_table)
                    sample_vals = c_table.general_c2_given_c1;
                    sample_mean = mean(sample_vals,'omitnan');
                    row.t1 = task1;
                    row.t2 = task2; 
                    row.c1 = c1;
                    row.c2 = c2;
                    row.sample_mean = sample_mean;
                    summary_table = [summary_table; row];
                end
            end
        end
    end
end

summary_table = struct2table(summary_table);
    
summary_table.t1c1 = summary_table.t1  + "_" + summary_table.c1;
summary_table.t2c2 = summary_table.t2  + "_" + summary_table.c2;

all_vals = summary_table.sample_mean;
total_mean = mean(all_vals,'omitnan');
total_std_dev = std(all_vals,'omitnan');

summary_table.dist_from_mean = (summary_table.sample_mean - total_mean) / total_std_dev;

end