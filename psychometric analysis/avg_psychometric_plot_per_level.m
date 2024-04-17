function avg_psychometric_plot_per_level(approach_data, type, constant, story_type, path_to_save)

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
    
    avg = [];
    figure
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
                plot(appr_rate)
                if length(appr_rate) < 4
                    continue
                end
                avg = [avg curr_table.approach_rate];
            else
                timings = curr_table.timing;
                plot(timings)
                avg = [avg timings];
            end
            xlabel(xlabel_str)
            title(constant + " level " + string(lvl) + " constant")
            ylabel(type)
            hold on
        end
    end
    
    num_subjects = length(unique(id_list));
    hold on
    means = mean(avg,2,'omitnan');
    plot(means,'LineWidth',5)
    xlabel(xlabel_str)
    title(constant + " level " + string(lvl) + " constant, # trials = " + num_trials + "# sessions = " + num_sessions + " # subjects = " + num_subjects)
    ylabel(ylabel_str)
    fighandle = gcf;
    savefig(fighandle,strcat(path_to_save,story_type,'/avg_psych_constant_',constant,'_lvl_',string(lvl),'.fig'))
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