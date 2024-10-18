%% example prims

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\prim_examples";
mkdir(save_to)

%% finding examples

sort_by = 'subj_var';
sorted_table = sortrows(prim_table, sort_by,'desc');

sorted_labels = unique(sorted_table.clusterLabels,'stable');
first_10 = sorted_labels(1:10);

%% individual exs

% subj var: 75295 -- moral story 12 + moral story 14
want_save = 1;
id = 75295;
task = "moral";
story = "story_12";
start_table = prim_table(prim_table.subjectidnumber == id &...
    prim_table.experiment == task &...
    prim_table.story_num == story, :);
subtit = "subj var: " + string(start_table.subj_var(1));

make_dec_making_plots(start_table, save_to, task , 1, 0, want_save,subtit)

%% r-c interact
% C:\Users\lrako\OneDrive\Documents\human dm\test_run\psych_stats\individual_overlays\approach_avoid\

% good separation  = 1464_approach_avoid_story_10 or
% 28690_approach_avoid_story_12

% bad separation
% 31657_social_story_12
