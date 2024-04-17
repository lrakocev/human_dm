function end_table = read_hr_csv_to_table(table_name)

opts = spreadsheetImportOptions('NumVariables',16,'VariableNamingRule',"preserve");
fin_table = readtable(table_name,opts,'ReadVariableNames',true);
% minimal cleaning
fin_table = removevars(fin_table, "Var1");
fin_table(1,:) = [];
fin_table.Properties.VariableNames = {'index', 'subjectidnumber','tasktypedone','decision_made','real_r','real_c','bpm','timesteps',...
	'number_of_timesteps','avg_hr','raw_max_hr','raw_min_hr','percent_max_hr','percent_min_hr','direction'};

first_convert = convertvars(fin_table,{'index', 'subjectidnumber','tasktypedone','decision_made','real_r','real_c','bpm','timesteps',...
	'number_of_timesteps','avg_hr','raw_max_hr','raw_min_hr','percent_max_hr','percent_min_hr','direction'},'string');

% done in two steps because you can't convert directly from cell to double
end_table = convertvars(first_convert, {'index', 'subjectidnumber','decision_made','real_r','real_c','bpm','timesteps',...
	'number_of_timesteps','avg_hr','raw_max_hr','raw_min_hr','percent_max_hr','percent_min_hr','direction'}, "double");


end
