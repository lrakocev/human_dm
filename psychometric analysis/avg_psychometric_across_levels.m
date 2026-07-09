function [h,all,lvl_lens] = avg_psychometric_across_levels(approach_data, type, constant, story_type, color, path_to_save,want_save)

if want_save
    figure
end
all = [];
num_sessions = 0;
num_trials = 0;
id_list = [];
lvl_lens = [];
for lvl = 1:4
        if isequal(constant, "cost")
            xlabel_str = "reward";
        else
            xlabel_str = "cost";
        end
        if isequal(type, "approach_rate")
            ylabel_str = "Mean Appr.";
        else
            ylabel_str = "timing";
        end
        
        lvl_len = 0;
        for N = 1:length(approach_data)
            appr_table = approach_data{N};
            subjectid = appr_table.subjectidnumber(1);
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
                lvl_len = lvl_len + height(curr_table);
                if isequal(type, "approach_rate")
                    appr_rate = curr_table.approach_rate;
                    if length(appr_rate) < 4
                        continue
                    end
                    all = [all appr_rate];
                else
                    timings = curr_table.timing;
                    all = [all timings];
                end

           ylabel(type)
           end
        end
        lvl_lens = [lvl_lens; lvl_len];
end

num_subjects = length(unique(id_list));
    
hold on
means = mean(all,2, 'omitnan');
s = std(all, 0, 2) / sqrt(length(all));
plot(means,'LineWidth',5,'Color',color);
hold on
h = errorbar(1:length(means),means,s,'LineWidth',5);
hold off
xlabel(xlabel_str)
ylabel(ylabel_str)
if want_save
    title(constant + "s constant, # trials = " + num_trials + "# sessions = " + num_sessions + " # subjects = " + num_subjects)
    fighandle = gcf;
    savefig(fighandle,strcat(path_to_save,'/avg_psych_constant_',string(subjectid),'_',story_type,'_',constant,'_across_lvls.fig'))
    close all
end
end

function table = get_curr_table(appr_table, lvl, constant)
   
    if isequal(constant,"cost")
        table = appr_table(appr_table.cost == lvl,:);
    else
        table = appr_table(appr_table.rew == lvl,:);
    end


end
