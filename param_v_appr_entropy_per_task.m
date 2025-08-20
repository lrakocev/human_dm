function param_v_appr_entropy_per_task(merged_table,num_bins)

tasks = unique(merged_table.experiment);

all_rows = [];
measures = ["pupil_diameter", "heart_rate", "pain", "hunger", "tiredness", "story_prefs", "cost", "rew"];

for i = 1:length(measures)
    measure = measures(i);

    figure(i)
    for j = 1:length(tasks)
        task = tasks(j);
        task_table = merged_table(merged_table.experiment == task, :);

        appr_entropy_table = parameters_per_appr_entropy(task_table,num_bins,measure);
    
        %{
        figure
        scatter(appr_entropy_table.(measure+"_lvl"), appr_entropy_table.appr_entropy)
        title(measure + " vs appr entropy")
        ylabel("appr entropy")
        xlabel(measure)
            
        figure
        scatter(appr_entropy_table.(measure+"_lvl"), appr_entropy_table.appr_mean)
        title(measure + " vs appr mean")
        ylabel("appr mean")
        xlabel(measure)
        %}
        
       if ~isempty(appr_entropy_table)
            hold on
            subplot(length(tasks),1,j)
           
            [prsq] = predict_appr_entropy(appr_entropy_table,measure,task);
        end
    end
    hold off

end
