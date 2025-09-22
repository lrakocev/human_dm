function all_data = group_same_day_stories(approach_data)

all_data = {};
counter = 1;
unique_ids = unique(approach_data.subjectidnumber);
for i = 1:length(unique_ids)
    id = unique_ids(i);
    id_table = approach_data(approach_data.subjectidnumber == id, :);
    if ~isempty(id_table)
         clean_dates = rowfun(@clean_date, id_table, "InputVariables", ...
                "trial_end", "OutputVariableNames", "date");
        
         id_table.session_date = clean_dates.date;
        
        unique_dates = unique(id_table.session_date);
        for j = 1:length(unique_dates)
            curr_date = unique_dates(j);
            date_table = id_table(id_table.session_date == curr_date, :);
            all_data{counter} = date_table;
            counter = counter + 1;
        end 
    end
end
end

function [new_datetime] = clean_date(row)

char_date = char(row);
strip = char_date(5:end-4);
inputFormat = 'MMM dd HH:mm:ss.SSSSSS yyyy';
output = datetime(strip, "InputFormat", inputFormat);
[y,m,d] = ymd(output);
new_datetime = datetime(y,m,d);

end