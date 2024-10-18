function new_table = get_rat_var(sesh_table)

subjects = unique(sesh_table.subjectid);
new_table = [];

for i = 1:length(subjects)
    subject = subjects(i);
    subject_table = sesh_table(sesh_table.subjectid == string(subject), :);
    subject_table.sesh_var = repelem(calc_var(subject_table), height(subject_table), 1);

    new_table = [new_table; subject_table];
end
end


function variance = calc_var(subject_table)

sub_sessions = unique(subject_table.clusterLabels);
apprs = [];
for j = 1:length(sub_sessions)
    sesh = sub_sessions(j);
    sesh_table = subject_table(subject_table.clusterLabels == sesh, :);
    apprs = [apprs; sesh_table.y1; sesh_table.y2; sesh_table.y3; sesh_table.y4];
end
variance = var(apprs);
end


