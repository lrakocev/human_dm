function [general_table,total_subjects] = chain_behavior_across_tasks_individual(all_psych_data, task1, task2, samp_size,num_samples)

task1_psych_data = all_psych_data(all_psych_data.story_type == task1, :);
task2_psych_data = all_psych_data(all_psych_data.story_type == task2, :);

[~,samp_task1] = bootstrp(samp_size,[],task1_psych_data);
[~,samp_task2] = bootstrp(samp_size,[],task2_psych_data);

general_table = [];
for sample_i = 1:num_samples
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
            tot_num_subj_pts = sum(prob_table.GroupCount);
            prob_table.tot_num_subj_pts = repelem(tot_num_subj_pts, height(prob_table), 1);
            subj_cluster_probs = [subj_cluster_probs; prob_table];
        
        end
    end
 
   t1_table = subj_cluster_probs(subj_cluster_probs.story_type == task1, :);
   t2_table = subj_cluster_probs(subj_cluster_probs.story_type == task2, :);

   t1_clusters = unique(t1_table.idx);
   t2_clusters = unique(t2_table.idx);

   cluster_overlaps = [];
   for i = 1:length(t1_clusters)
       c1 = t1_clusters(i);
       ids_in_c1 = t1_table(t1_table.idx == c1, :).subjectidnumber;

       for j = 1:length(t2_clusters)
            c2 = t2_clusters(j);
            c2_table = t2_table(t2_table.idx == c2, :);

            tot_in = 0;
            tot_out = 0;
            ids_in_both = [];
            for k = 1:height(c2_table)
                row = c2_table(k,:);
                subj_id = row.subjectidnumber;
                if ismember(subj_id,ids_in_c1)
                    tot_in = tot_in + row.GroupCount;
                    tot_out = tot_out + row.tot_num_subj_pts;
                    ids_in_both = [ids_in_both; subj_id];
                end
            end

            percent_in_c2_given_c1 = tot_in / (tot_in + tot_out);

            c_row.ids_in_both = {ids_in_both};
            c_row.c1 = c1;
            c_row.t1 = task1;
            c_row.c2 = c2;
            c_row.task2 = task2;
            c_row.percent_in_c2_given_c1 = percent_in_c2_given_c1;
           
            cluster_overlaps = [cluster_overlaps; c_row];
       end
   end

   cluster_overlaps = struct2table(cluster_overlaps);

   individual_overlaps = [];
   for i = 1:length(subjects)
        id = subjects(i);
        for j = 1:height(cluster_overlaps)
            row = cluster_overlaps(j, :);
            ids_in_row = row.ids_in_both{1,1};
            if ismember(id,ids_in_row)
                c1 = row.c1;
                c2 = row.c2;
                percent_in_c2_given_c1 = row.percent_in_c2_given_c1;

                percent_id_c1 = subj_cluster_probs(subj_cluster_probs.subjectidnumber...
                    == id & subj_cluster_probs.idx == c1 & subj_cluster_probs.story_type == task1, :).Percent;
                percent_id_c2 = subj_cluster_probs(subj_cluster_probs.subjectidnumber...
                    == id & subj_cluster_probs.idx == c2 & subj_cluster_probs.story_type == task2, :).Percent;

                cond_prob = (percent_in_c2_given_c1 * percent_id_c1) / percent_id_c2;

                i_row.subjectnumberid = id;
                i_row.c1 = c1;
                i_row.t1 = task1;
                i_row.c2 = c2;
                i_row.t2 = task2;
                i_row.cond_prob = cond_prob;
                individual_overlaps = [individual_overlaps; i_row];
            end 
        end
   end

    individual_overlaps = struct2table(individual_overlaps);

    normalizing_overlaps = [];

    grouped = groupsummary(individual_overlaps,["subjectnumberid","t1","c1"],"sum","cond_prob");
    for i = 1:height(individual_overlaps)
        row = individual_overlaps(i,:);
        id = row.subjectnumberid;
        t1 = row.t1;
        c1 = row.c1;

        sum_cond_prob = grouped(grouped.subjectnumberid == id & grouped.t1 == t1 & grouped.c1 == c1, :).sum_cond_prob;
        row.cond_prob = row.cond_prob / sum_cond_prob;

        normalizing_overlaps = [normalizing_overlaps; row];

    end
    
    general_table = [general_table; normalizing_overlaps];
    end
 
end