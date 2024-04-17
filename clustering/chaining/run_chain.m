function total_table = run_chain(tasks,sample_size)

total_table = [];
for t1 = 1:length(tasks)
    for t2 = 1:length(tasks)
        task1 = tasks(t1);
        task2 = tasks(t2);
        if task1 == task2
            continue
        end
        [general_table,~] = chain_behavior_across_tasks(all_psych_data, task1, task2, sample_size);
        total_table = [total_table;general_table];
    end
end
save("total_table.mat","total_table")
end