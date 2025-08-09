function [general_table,total_subjects] = chain_behavior_across_tasks(all_psych_data, task1, task2, samp_size)
% this function is a mess and i need to clean it up

task1_psych_data = all_psych_data(all_psych_data.story_type == task1, :);
task2_psych_data = all_psych_data(all_psych_data.story_type == task2, :);

[~,samp_task1] = bootstrp(samp_size,[],task1_psych_data);
[~,samp_task2] = bootstrp(samp_size,[],task2_psych_data);

general_table = [];
sample_i = 1;
%for sample_i = 1:samp_size
    task1_sample_idx = samp_task1(:,sample_i);
    task2_sample_idx = samp_task2(:,sample_i);

    task1_sample_data = task1_psych_data(task1_sample_idx,:);
    task2_sample_data = task2_psych_data(task2_sample_idx,:);
    sample_psych_data = [task1_sample_data; task2_sample_data];
    
    clusters_in_sample = unique(sample_psych_data.idx);
    subjects = unique(sample_psych_data.subjectidnumber);
    tasks_to_consider = [task1, task2];
    
    subj_cluster_probs = [];
    total_subjects = 0;
    for i = 1:length(subjects)
        id = subjects(i);
        id_table = sample_psych_data(sample_psych_data.subjectidnumber== id, :);
    
        tasks = unique(id_table.story_type);
    
        if ~all(ismember(tasks_to_consider,tasks))
            continue
        end
    
        total_subjects = total_subjects + 1;
        for t = 1:length(tasks_to_consider)
            task = tasks_to_consider(t);
            task_table = id_table(id_table.story_type == task, :);
    
            prob_table = groupcounts(task_table,"idx");
            prob_table.story_type = repelem(task, height(prob_table), 1);
            prob_table.subjectidnumber= repelem(id, height(prob_table), 1);
            subj_cluster_probs = [subj_cluster_probs; prob_table];
        
        end
    end
    
    all_tasks = unique(sample_psych_data.story_type);
    
    further_probs = [];
    
    for t = 1:length(all_tasks)
        task = all_tasks(t);
        for i = 1:length(clusters_in_sample)
            cluster = clusters_in_sample(i);
            task_cluster_table = subj_cluster_probs(subj_cluster_probs.story_type == task...
                & subj_cluster_probs.idx == cluster, :);
            
            total_cluster_size = sum(task_cluster_table.GroupCount);
    
            task_cluster_table.percent_of_group = task_cluster_table.GroupCount / total_cluster_size;
            task_cluster_table.cluster_size = repelem(total_cluster_size, height(task_cluster_table),1);
    
    
            further_probs = [further_probs; task_cluster_table];
        end
    end
    
    full_table = [];
    for n = 1:length(clusters_in_sample)
        c1 = clusters_in_sample(n);
        task1_cluster_table = further_probs(further_probs.story_type == task1 & further_probs.idx == c1, :);
        ids_in_cluster = task1_cluster_table.subjectidnumber;
    
        for m = 1:length(clusters_in_sample)
            c2 = clusters_in_sample(m);
            for i = 1:length(ids_in_cluster)
                id = ids_in_cluster(i);
         
                task1_id_table = task1_cluster_table(task1_cluster_table.subjectidnumber== id,:);
    
                task2_cluster_table = further_probs(further_probs.story_type == task2...
                    & further_probs.idx == c2, :);
    
                task2_id_table = further_probs(further_probs.story_type == task2...
                    & further_probs.subjectidnumber== id & further_probs.idx == c2, :);
    
                % TODO: before i was taking size from task2_id_table-why?
                if ~isempty(task2_id_table)
                    new_table.task1 = task1;
                    new_table.c1 = c1;
                    new_table.c1_size = task1_cluster_table.cluster_size(1);
                    new_table.task2 = task2;
                    new_table.c2 = c2;
                    new_table.c2_size = task2_cluster_table.cluster_size(1);
                    new_table.subjectidnumber= id; 
                    new_table.percent_of_c1_is_id = task1_id_table.percent_of_group;
                    new_table.percent_of_c2_is_id = task2_id_table.percent_of_group;
                    new_table.percent_of_id_in_c1 = task1_id_table.Percent / 100;
                    new_table.percent_of_id_in_c2 = task2_id_table.Percent / 100;
                    
                    full_table = [full_table; new_table];
                end
    
            end
        end
    end
    
    total_task2 = sum(further_probs(further_probs.story_type == task2, :).GroupCount);
    full_table = struct2table(full_table);
    full_table.product_pct_c2_prop_c1 = full_table.percent_of_id_in_c2.*full_table.percent_of_c1_is_id; 
    
    intermed_table = [];
    for i1 = 1:length(clusters_in_sample)
        c1 = clusters_in_sample(i1);
        for i2 = 1:length(clusters_in_sample)
           c2 = clusters_in_sample(i2);
           curr_table = full_table(full_table.c1 == c1 & full_table.c2 == c2, :);
            
           if ~isempty(curr_table)
               c2_size = curr_table.c2_size(1);
               row.task1 = task1; 
               row.task2 = task2; 
               row.c1 = c1; 
               row.c2 = c2;
               row.sample = sample_i;
               row.general_c2_given_c1 = sum(curr_table.product_pct_c2_prop_c1,'omitmissing') / (c2_size/total_task2);
               intermed_table = [intermed_table; row];
           end
        end
    end
    
    intermed_table = struct2table(intermed_table);
    
    for i = 1:length(clusters_in_sample)
        c2 = clusters_in_sample(i);
        tot = sum(intermed_table(intermed_table.c2 == c2,:).general_c2_given_c1);
        intermed_table(intermed_table.c2 == c2, :).general_c2_given_c1 = ...
            intermed_table(intermed_table.c2 == c2, :).general_c2_given_c1 / tot;
    end
    general_table = [general_table; intermed_table];
end

    
%end