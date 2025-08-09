function result_str = physio_tasks_anova(merged_table, story_types, is_hr, use_all)

xs = [];
ys = [];
zs = [];
ls = [];
for s = 1:length(story_types)
    story = story_types(s);
    task_table = merged_table(merged_table.experiment == story, :);
    ls = [ls; height(task_table)];

    if ~is_hr
        x = task_table.avg_eng;
        y = task_table.num_maxes;
        z = task_table.num_mins;

        xs = [xs;x];
        ys = [ys;y];
        zs = [zs;z];
        
    else
        x = task_table.percent_max_hr;
        y = task_table.percent_min_hr;
        z = task_table.direction;

        xs = [xs;x];
        ys = [ys;y];
        zs = [zs;z];
        feature = "% max HR above avg";
    end
end

% Combine data
if use_all
    responseData = [xs; ys; zs]';
else
    responseData = [xs]';
end

% Create factor vectors
aa = repelem("aa", ls(1));
soc = repelem("s", ls(2));
prob = repelem("p", ls(3));
mor = repelem("m", ls(4));

if use_all
    types = [aa soc prob mor aa soc prob mor aa soc prob mor];
else
    types = [aa soc prob mor];
end

feat1 = repelem("f1", length(xs));
feat2 = repelem("f2", length(ys));
feat3 = repelem("f3", length(zs));

if use_all
    feats = [feat1 feat2 feat3];
else
    feats = [feat1];
end

% Perform n-way ANOVA
[p,t,stats,terms] = anovan(responseData,{types; feats},"interaction");

if use_all
    result_str = "p-val of nway anova: " + string(p(1));
else
    result_str = "p-val of nway anova: " + string(p(1)) + " using " + feature + " ";
end    
for s = 1:length(story_types)
    story = story_types(s);
    result_str = result_str + newline + story +...
        " trials, n = " + string(ls(s));
end
end