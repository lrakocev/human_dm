%% example prims

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\prim_examples";
mkdir(save_to)

%% finding examples

sort_by = 'rawZ';
sorted_table = sortrows(prim_table, sort_by,'desc');

sorted_labels = unique(sorted_table.clusterLabels,'stable');
first_10 = sorted_labels(20:29);

%% individual exs

% subj var: 75295 -- moral story 12 + moral story 14
want_save = 1;
id = 60131;
task = "probability";
story = "story_3";
start_table = prim_table(prim_table.subjectidnumber == id &...
    prim_table.experiment == task &...
    prim_table.story_num == story, :);
subtit = "elasticity: " + string(start_table.rawZ(1));

make_dec_making_plots(start_table, save_to, task , 1, 0, want_save,subtit)

