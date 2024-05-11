function [general_table,total_subjects] = chain_behavior_across_tasks_pt2(all_psych_data, task1, task2, samp_size)

task1_psych_data = all_psych_data(all_psych_data.story_type == task1, :);
task2_psych_data = all_psych_data(all_psych_data.story_type == task2, :);

[~,samp_task1] = bootstrp(samp_size,[],task1_psych_data);
[~,samp_task2] = bootstrp(samp_size,[],task2_psych_data);

general_table = [];
sample_i = 1;
for sample_i = 1:samp_size
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
            prob_table.Percent = prob_table.Percent / 100;
            subj_cluster_probs = [subj_cluster_probs; prob_table];
        
        end
    end
   
    cluster_overlaps = [];
    
    t1_clusters = unique(task1_sample_data.idx);
    t2_clusters = unique(task2_sample_data.idx);

    for a = 1:length(t1_clusters)
        c1 = t1_clusters(a);
        for b = 1:length(t2_clusters)
            c2 = t2_clusters(b);
          
            t1c1_data = unique(all_psych_data(all_psych_data.story_type == task1 & all_psych_data.idx == c1, :));
            t2c2_data = unique(all_psych_data(all_psych_data.story_type == task2 & all_psych_data.idx == c2, :));

            t2c2_ids = unique(t2c2_data.subjectidnumber);
            
            tot_in = 0;
            tot_not = 0;
            for j = 1:height(t1c1_data)
                dat = t1c1_data(j,:);
                id = dat.subjectidnumber;
                if ismember(id, t2c2_ids)
                    tot_in = tot_in + 1;
                else
                    tot_not = tot_not + 1;
                end
            end
            c_row.t1 = task1;
            c_row.c1 = c1;
            c_row.t2 = task2;
            c_row.c2 = c2;
            c_row.in_both = tot_in;
            c_row.not_in_both = tot_not;
            c_row.overall_tot = tot_in + tot_not;
            c_row.percent_in =  tot_in / (tot_in + tot_not);
            cluster_overlaps = [cluster_overlaps; c_row];
        end
    end

    cluster_overlaps = struct2table(cluster_overlaps);
    updated_overlaps = [];

    for i = 1:height(cluster_overlaps)
        row = cluster_overlaps(i,:);
        t1 = row.t1;
        t2 = row.t2; 
        c1 = row.c1; 
        c2 = row.c2;

        percent_in = row.percent_in;

        t1_subj_table = subj_cluster_probs(subj_cluster_probs.idx == c1 & subj_cluster_probs.story_type == t1, :);
        t1_ids = unique(t1_subj_table.subjectidnumber);
        t2_subj_table = subj_cluster_probs(subj_cluster_probs.idx == c2 & subj_cluster_probs.story_type == t2, :);
        t2_ids = unique(t2_subj_table.subjectidnumber);

        intersect_ids = intersect(t1_ids, t2_ids);
        cluster_tot = [];
        for j = 1:length(intersect_ids)
            id = intersect_ids(j);

            t1_id_percent = t1_subj_table(t1_subj_table.subjectidnumber == id, :).Percent;
            t2_id_percent = t2_subj_table(t2_subj_table.subjectidnumber == id, :).Percent;
            
            cond_prob = (percent_in * t1_id_percent) / t2_id_percent;
            cluster_tot = [cluster_tot ; cond_prob];
        end
        cluster_avg = mean(cluster_tot, 'omitnan');
        row.general_c2_given_c1 = cluster_avg;
        updated_overlaps = [updated_overlaps; row];
        cluster_tot = [];

    end

    for i = 1:length(t1_clusters)
        c1 = t1_clusters(i);
        tot = sum(updated_overlaps(updated_overlaps.c1 == c1,:).general_c2_given_c1,'omitnan');
        updated_overlaps(updated_overlaps.c1 == c1, :).general_c2_given_c1 = ...
            updated_overlaps(updated_overlaps.c1 == c1, :).general_c2_given_c1 / tot;
    end
    general_table = [general_table; updated_overlaps];
    end
 
    
end