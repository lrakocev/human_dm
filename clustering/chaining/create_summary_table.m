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
                    sample_mean = mean(sample_vals);
                    std_dev = std(sample_vals);
                    row.t1 = task1;
                    row.t2 = task2; 
                    row.c1 = c1;
                    row.c2 = c2;
                    row.sample_mean = sample_mean;
                    row.std_dev = std_dev;
                    summary_table = [summary_table; row];
                end
            end
        end
    end
end

summary_table = struct2table(summary_table);
    
summary_table.t1c1 = summary_table.t1  + "_" + summary_table.c1;
summary_table.t2c2 = summary_table.t2  + "_" + summary_table.c2;
summary_table.std_devs_from_mean = zeros(height(summary_table),1);

avgd = 1;
num_clusters = 5;
tasks = ["approach_avoid","social","moral","probability"];
for t = 1:length(tasks)
    t1 = tasks(t);
    for s = 1:length(tasks)
        t2 = tasks(s);
        for c1 = 1:num_clusters
            sub_table = summary_table(summary_table.t1 == t1 & ...
                summary_table.t2 == t2 & summary_table.c1 == c1, :);
            if ~isempty(sub_table)
                mean_prob = mean(sub_table.sample_mean);
                if ~avgd
                    new_vals = (sub_table.sample_mean - mean_prob) / sub_table.std_dev;
                    summary_table(summary_table.t1 == t1 & ...
                    summary_table.t2 == t2 & summary_table.c1 == c1, :).std_devs_from_mean = new_vals(:,5);
                else
                    mean_std = mean(sub_table.std_dev);
                    new_vals = (sub_table.sample_mean - mean_prob) / mean_std;
                    summary_table(summary_table.t1 == t1 & ...
                    summary_table.t2 == t2 & summary_table.c1 == c1, :).std_devs_from_mean = new_vals;
                end

            end
        end
    end
end
end