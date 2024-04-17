function all_trials = avg_rew_v_cost_comparison_per_lvl(approach_data, type, constant, story_type, path_to_save)

figure

if constant == "reward"
    xlabelstr = "cost";
else
    xlabelstr = "reward";
end

num_sessions = 0;
num_subjects = 0;
num_trials = 0;
id_list = [];
all_trials = [];
lvl_ps = [];
for lvl = 1:4
    avg = [];
    lvl_table = [];
    for N = 1:length(approach_data)
        appr_table = approach_data{N};
        if ~isempty(appr_table)
            all_trials = [all_trials; appr_table];
            num_sessions = num_sessions + 1;
            try 
                id = appr_table.subjectidnumber{1};
            catch
                id = appr_table.subjectidnumber(1);
            end
            id_list = [id_list; id];
            curr_table = get_curr_table(appr_table, lvl, constant);
            lvl_table = [lvl_table; curr_table];
            num_trials = num_trials + height(appr_table);
            num_stories = unique(curr_table.story_num);
            if isequal(type, "approach rate")
                appr_rate = curr_table.approach_rate;
                if length(appr_rate) < 4
                    continue
                end
                avg = [avg appr_rate];
            else
                timings = curr_table.timing;
                avg = [avg timings];
            end
        end
    end
    hold on
    means = mean(avg,2,'omitnan');
    plot(means,'LineWidth',5)

    [lvl_p, ~, ~, ~] = psychometric_anova(lvl_table, xlabelstr);
    lvl_ps = [lvl_ps; "lvl" + string(lvl) + ": " + string(lvl_p)];
end

all_ps = strjoin(lvl_ps, ", ");

[p,t,stats,terms] = psychometric_anova(all_trials, constant);

num_subjects = length(unique(id_list));
title(constant + " constant across levels, # trials = " + num_trials + "# sessions = " + num_sessions + " # subjects = " + num_subjects)
subtitle('p-val of anova across lines: ' + string(p) + ', p-val of anova for each line: ' + all_ps)
ylabel(type)
xlabel(xlabelstr)
ylabel(type)
legend(['lvl 1';'lvl 2';'lvl 3';'lvl 4'])
fighandle = gcf;
savefig(fighandle,strcat(path_to_save,story_type,'/',constant,'across_lvls.fig'))
close all
end

function table = get_curr_table(appr_table, lvl, constant)
   
    if isequal(constant,"cost")
        table = appr_table(appr_table.cost == lvl,:);
    else
        table = appr_table(appr_table.rew == lvl,:);
    end


end