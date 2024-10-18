function num_pts = color_raw_feats_by_task(feat_table)

feat_table = feat_table(~ismissing(feat_table.story_type), :);
stories = unique(feat_table.story_type);
colors = distinguishable_colors(length(stories));

num_pts = 0;
hs = [];
figure
for i = 1:length(stories)
    story = stories(i);
    col = colors(i,:);
    story_table = feat_table(feat_table.story_type == story, :);
    num_pts = num_pts + height(story_table);

    x = log(story_table.med_appr);
    y = log(story_table.c_interact);
    z = log(story_table.subj_var);

    h =  scatter3(x,y,z,[],col);
    hs = [hs; h];
    hold on
end

xlabel('med appr')
ylabel('c interact')
zlabel('subj var')
legend(hs,stories)
title('raw feats colored by task type')
hold off
end