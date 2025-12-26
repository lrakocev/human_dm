function [func] = cell_data_single_psych(trial_table)

rews = unique(trial_table.Solenoid);
costs = unique(trial_table.LED);

summary_table = [];
for r = 1:length(rews)
    rew = rews(r);
    for c = 1:length(costs)
        cost = costs(c);            
        r_c_table = trial_table(trial_table.Solenoid == rew & trial_table.LED == cost, :);
        avg_licks = mean(r_c_table.LicksInOutcome,'omitnan');
        row.r = rew;
        row.c = cost;
        row.licks = avg_licks;
        summary_table = [summary_table; row];
    end

end

summary_table = struct2table(summary_table);
rew_table = summary_table(summary_table.c == 0, :);

x = rew_table.r;
y = rew_table.licks;

counter = 0;

[func, gof_sig] = fit(x,y,'(a/(1+b*exp(-c*(x))))');
while counter < 20 && gof_sig.rsquare < .7
    [func, gof_sig] = fit(x,y,'(a/(1+b*exp(-c*(x))))');
    counter = counter+1;
end 

end