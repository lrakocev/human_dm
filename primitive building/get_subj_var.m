function new_table = get_subj_var(full_table)

subjects = unique(full_table.subjectidnumber);
new_table = [];
for i = 1:length(subjects)
    subject = subjects(i);
    subject_table = full_table(full_table.subjectidnumber == subject, :);

    try
        avg_sub_psych = get_avg_psych(subject_table);
    catch
        continue
    end
    sub_sessions = unique(subject_table.clusterLabels);
    for j = 1:length(sub_sessions)
        sesh = sub_sessions(j);
        sesh_table = subject_table(subject_table.clusterLabels == sesh, :);
        
        [variance, diffs] = compare_avg_to_indiv(avg_sub_psych, sesh_table);
        sesh_table.subj_var = repelem(variance, height(sesh_table), 1);
        sesh_table.diffs_from_sub_avg = repelem(diffs, height(sesh_table), 1);
        new_table = [new_table; sesh_table];
        
    end
end

end

