function total_table = run_indiv_chain(all_psych_data,tasks,sample_size,save_to,num_samples)

total_table = [];
for t1 = 1:length(tasks)
    for t2 = 1:length(tasks)
        task1 = tasks(t1);
        task2 = tasks(t2);
        if task1 == task2
            continue
        end
        [general_table,~] = chain_behavior_across_tasks_individual(all_psych_data, task1, task2, sample_size,num_samples);
        total_table = [total_table;general_table];
    end
end
save(save_to + "total_table_individual.mat", "total_table")
end