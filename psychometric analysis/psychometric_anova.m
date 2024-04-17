function [p,t,stats,terms] = psychometric_anova(appr_table, cost_or_rew)

if cost_or_rew == "reward"
    l1 = appr_table(appr_table.rew == 1, :).approach_rate;
    l2 = appr_table(appr_table.rew == 2, :).approach_rate;
    l3 = appr_table(appr_table.rew == 3, :).approach_rate;
    l4 = appr_table(appr_table.rew == 4, :).approach_rate;
else
    l1 = appr_table(appr_table.cost == 1, :).approach_rate;
    l2 = appr_table(appr_table.cost == 2, :).approach_rate;
    l3 = appr_table(appr_table.cost == 3, :).approach_rate;
    l4 = appr_table(appr_table.cost == 4, :).approach_rate;
end

% Combine data
responseData = [l1; l2; l3; l4]';

% Create factor vectors
lvl_1 = repelem(1, length(l1));
lvl_2 = repelem(2, length(l2));
lvl_3 = repelem(3, length(l3));
lvl_4 = repelem(4, length(l4));

lvls = [lvl_1 lvl_2 lvl_3 lvl_4];

% Perform n-way ANOVA
[p,t,stats,terms] = anovan(responseData, {lvls}, 'varnames', {'levels'},'display','off');
end