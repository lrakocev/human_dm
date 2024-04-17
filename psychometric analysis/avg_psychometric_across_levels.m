function avg_psychometric_across_levels(approach_data, type, constant, story_type, path_to_save)

figure
avg = [];
num_sessions = 0;
num_trials = 0;
id_list = [];
for lvl = 1:4
        if isequal(constant, "cost")
            xlabel_str = "reward";
        else
            xlabel_str = "cost";
        end
        if isequal(type, "appr_rate")
            ylabel_str = "approach rate";
        else
            ylabel_str = "timing";
        end
        
        for N = 1:length(approach_data)
            appr_table = approach_data{N};
            if ~isempty(appr_table)
                try 
                    id = appr_table.subjectidnumber{1};
                catch
                    id = appr_table.subjectidnumber(1);
                end
                id_list = [id_list; id];
                num_sessions = num_sessions + 1;
                curr_table = get_curr_table(appr_table, lvl, constant);
                num_trials = num_trials + height(appr_table);
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

           ylabel(type)
           end
        end
end

num_subjects = length(unique(id_list));
m = mean(mean(avg),'omitnan');
s = std(avg, 0, 'all');
    
hold on
means = mean(avg,2, 'omitnan');
plot(means,'LineWidth',5)
xlabel(xlabel_str)
title(constant + "s constant, # trials = " + num_trials + "# sessions = " + num_sessions + " # subjects = " + num_subjects)
ylabel(ylabel_str)
fighandle = gcf;
savefig(fighandle,strcat(path_to_save,story_type,'/avg_psych_constant',constant,'_across_lvls.fig'))
close all
end

function table = get_curr_table(appr_table, lvl, constant)
   
    if isequal(constant,"cost")
        table = appr_table(appr_table.cost == lvl,:);
    else
        table = appr_table(appr_table.rew == lvl,:);
    end


end
