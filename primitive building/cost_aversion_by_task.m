function p = cost_aversion_by_task(prim_table, stories)

means = [];
serrs = [];
anova = [];
costs = [];
ls = [];
for i = 1:length(stories)
    story = stories(i);
    story_table = prim_table(prim_table.experiment == story, :);
    story_table = story_table(story_table.cost ~= 0, :);
    
    data = story_table.approach_rate;
    cost = story_table.cost;

    costs = [costs; cost];
    anova = [anova; data];
    ls = [ls; height(data)];

end

p = calc_anova(anova, costs, stories, ls);

end

function p = calc_anova(data, costs, stories, ls)

tasks = [];
for l = 1:length(ls)
    len = ls(l);
    s = stories(l);
    tasks = [tasks repelem(s, len)];
end

[p,t,stats,terms] = anovan(data,{tasks;costs},'model','interaction','varnames',{'tasks';'costs'});

end
