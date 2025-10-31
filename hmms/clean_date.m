function output = clean_date(row)

char_date = char(row);
strip = char_date(5:end-4);
inputFormat = 'MMM dd HH:mm:ss.SSSSSS yyyy';
output = datetime(strip, "InputFormat", inputFormat);

end
