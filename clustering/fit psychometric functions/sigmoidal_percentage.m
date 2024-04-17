function fin_summary = sigmoidal_percentage(starting_dir, story_types)

fin_summary = "";
for i = 1:4
    story = story_types(i);
    story_dir = starting_dir + story + "\";
    sigmoid_dir = story_dir + "Sigmoid Data";
    parabola_dir = story_dir + "Parabola Data";
    line_dir = story_dir + "Line Data";
    
    sig_d = dir(sigmoid_dir);
    num_sig = length(sig_d);

    par_d =  dir(parabola_dir);
    num_par = length(par_d);

    line_d = dir(line_dir);   
    num_line = length(line_d);

    total = num_sig + num_line + num_par;

    sig_percent = 100 * num_sig / total; 

    par_percent = 100 * num_par / total;
    line_percent = 100 * num_line / total;

    summary = story + " has " + string(sig_percent) + "% sigmoids, " + ...
        string(par_percent) + "% parabolas, and " + string(line_percent) + ...
        "% line psychometric functions. ";

    fin_summary = fin_summary + summary;

end

end
