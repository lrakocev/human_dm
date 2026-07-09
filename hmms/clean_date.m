function output = clean_date(row)

char_date = char(row);
split_date = split(char_date, ";");
date_only = split_date(1);
strip = date_only(5:end-4);
inputFormat = 'MMM dd HH:mm:ss.SSSSSS yyyy';
try
    output = datetime(strip, "InputFormat", inputFormat);
catch
    inputFormat = 'eee MMM dd HH:mm:ss yyyy';
    output = datetime(date_only, "InputFormat", inputFormat);
end
end
