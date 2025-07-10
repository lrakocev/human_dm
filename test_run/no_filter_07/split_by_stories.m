function split_by_stories(table_of_data, want_hold)

% for old_approach_avoid
good_old_stories = [2, 3, 6, 9, 12, 14, 15, 16, 21, 22];
bad_old_stories = [1, 4, 7, 8, 10, 11, 13, 17, 18];
maybe_old_stories = [2, 5, 9, 12, 19, 20];
optimistic = [10, 19];
pessimistic = [1, 5, 7, 8, 18, 20];

% for social
bad_social = [1, 3, 4, 6, 7, 8, 23, 24];
multi_social = [11, 12, 13, 14, 15, 16, 17, 18, 19];
good_social = [2, 5, 9, 10, 20, 21, 22];

% for prob
bad_prob = [1, 2, 5, 6, 8, 12];
good_prob = [3, 4, 7, 9, 10, 11, 19, 20, 22, 23];
social_prob = [13, 14, 15, 16, 17, 18, 21, 24];

table_of_data.split = split(table_of_data.D, ["_","."]);
table_of_data.id = table_of_data.split(:,1);
table_of_data.story = string(table_of_data.split(:,3));
table_of_data.split = [];

colors = distinguishable_colors(10);

figure
good_old_appr_av = plot_by_story_type(table_of_data, "old_approach_avoid",good_old_stories, "good old appr avoid", colors(1,:), want_hold);
appr_avoid = plot_by_story_type(table_of_data, "approach_avoid",good_old_stories, "good new appr avoid", colors(1,:), want_hold);

social = plot_by_story_type(table_of_data, "social", good_social, "good social",colors(2,:), want_hold);

prob = plot_by_story_type(table_of_data, "probability",good_prob, "good prob",colors(3,:), want_hold);
social_prob = plot_by_story_type(table_of_data, "probability",social_prob, "prob that seem social",colors(4,:), want_hold);

moral = plot_by_story_type(table_of_data, "moral",[], "moral",colors(5,:), want_hold);

nonsense = plot_by_story_type(table_of_data, "old_approach_avoid",bad_old_stories, "nonsense", colors(6,:), want_hold);

super = plot_by_story_type(table_of_data, "super",bad_old_stories, "super", colors(7,:), want_hold);

if want_hold
    order = ["old appr avoid", "new appr avoid", "social", "prob that seem social", "prob", "moral","nonsense"];
    legend([good_old_appr_av, appr_avoid, social, social_prob, prob, moral, nonsense], order)
    hold off
    
end

hold off

figure
maybe_nonsense = plot_by_story_type(table_of_data, "old_approach_avoid",maybe_old_stories, "maybe nonsense", colors(7,:), want_hold);
optimistic = plot_by_story_type(table_of_data, "old_approach_avoid",optimistic, "optimistic", colors(8,:), want_hold);
pessimistic = plot_by_story_type(table_of_data, "old_approach_avoid",pessimistic, "pessimistic", colors(9,:), want_hold);

if want_hold
    order_v2 = ["optimistic", "pessimistic"];
    legend([optimistic, pessimistic],order_v2)
end

end

function h = plot_by_story_type(table_of_data, task_type, story_list, tit_str, color, want_hold)

if ~want_hold
    figure
end
if ~isempty(story_list)
    story_table = table_of_data(table_of_data.E == task_type & ismember(table_of_data.story,string(story_list)), :);
else
    story_table = table_of_data(table_of_data.E == task_type, :);
end

coords = log(abs([story_table.A, story_table.B, story_table.C]));

h = scatter3(coords(:,1), coords(:,2), coords(:,3), 10, color, 'filled');
xlim([-10 10])
ylim([-20 20])
zlim([-30 10])
if want_hold
    hold on
else
    title(tit_str)
    hold off
end

end