function new_table = get_sesh_var(sesh_table, clusterLabel)

subjects = unique(sesh_table.subjectidnumber);
new_table = [];
for i = 1:length(subjects)
    subject = subjects(i);
    subject_table = sesh_table(sesh_table.subjectidnumber == subject, :);
    subject_table.sesh_var = repelem(calc_var(subject_table, clusterLabel), height(subject_table), 1);
    new_table = [new_table; subject_table];
end

end

function variance = calc_var(subject_table,clusterLabel)

sub_sessions = unique(subject_table.(clusterLabel));
for j = 1:length(sub_sessions)
    sesh = sub_sessions(j);
    sesh_table = subject_table(subject_table.(clusterLabel) == sesh, :);

    [~, unique_indices] = unique([sesh_table.rew,sesh_table.cost], 'stable','rows');
    sesh_table = sesh_table(unique_indices, :);

    middle_section = sesh_table(abs(sesh_table.rew - sesh_table.cost) <= 1, :);
    variance = var(middle_section.approach_rate);
end

end

