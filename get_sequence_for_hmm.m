function seq_table = get_sequence_for_hmm(input_table, features, num_lvls)

updated_table = rowfun(@clean_date, input_table, "InputVariables", ...
    "trial_end", "OutputVariableNames", "clean_date");
input_table.clean_date = updated_table.clean_date;
input_table = sortrows(input_table,"clean_date","ascend");

symbols = (1:num_lvls);
symbol_chars = num2cell(symbols); % convertStringsToChars(symbols);

for i = 1:length(features)
    feature = features(i);
    raw_seq = input_table.(feature);
    clean_seq = fillmissing(raw_seq, 'knn',5);
    
    thresholds = get_thresh_lvls(clean_seq, num_lvls);
    seq = apply_threshold_to_seq(clean_seq, thresholds, symbol_chars);
    seq_table.(feature) = seq; 
end

seq_table = struct2table(seq_table);
end

function output = clean_date(row)

char_date = char(row);
strip = char_date(5:end-4);
inputFormat = 'MMM dd HH:mm:ss.SSSSSS yyyy';
output = datetime(strip, "InputFormat", inputFormat);

end

function lvls = get_thresh_lvls(feature_col, num_lvls)

max_val = max(feature_col);
min_val = min(feature_col);

increment = (abs(min_val)+abs(max_val))/num_lvls;
lvls = min_val:increment:max_val;
lvls = lvls(2:end);
end

function abbrs = get_abbrs(str, num_lvls, want_abbr)

    if want_abbr
        str = replace(str, "_", " ");
        first_letters = regexp(str,  '(\<[a-zA-Z])', 'match'); 
        abbr = strjoin(first_letters,'');
    else 
        abbr = "s";
    end

    str_lvls = string(1:num_lvls);
    abbrs = abbr + str_lvls;
end
