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
    if num_lvls > 0
        clean_seq = fillmissing(raw_seq, 'knn',5);
        
        thresholds = get_thresh_lvls(clean_seq, num_lvls);
        seq = apply_threshold_to_seq(clean_seq, thresholds, symbol_chars);
    else
        seq = raw_seq;
    end
    seq_table.(feature) = seq; 
end

seq_table = struct2table(seq_table);
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
