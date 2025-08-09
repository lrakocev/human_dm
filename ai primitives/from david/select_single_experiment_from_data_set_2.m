function [updated_table] = select_single_experiment_from_data_set_2(human_data_table,name_of_experiment_you_want)
updated_table = human_data_table(strcmp(human_data_table.experiment,name_of_experiment_you_want),:);
end