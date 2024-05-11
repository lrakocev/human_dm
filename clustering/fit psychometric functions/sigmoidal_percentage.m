function fin_summary = sigmoidal_percentage(starting_dir, story_types, save_to)

fin_summary = "";
total_sig = 0;
total_par = 0;
total_line = 0;
total_total = 0;
for i = 1:4
    story = story_types(i);
    story_dir = starting_dir + story + "\";
    sigmoid_dir = story_dir + "Sigmoid Data";
    parabola_dir = story_dir + "Parabola Data";
    line_dir = story_dir + "Line Data";
    
    sig_d = dir(sigmoid_dir);
    num_sig = length(sig_d);
    total_sig = total_sig + num_sig;

    par_d =  dir(parabola_dir);
    num_par = length(par_d);
    total_par = total_par + num_par;

    line_d = dir(line_dir);   
    num_line = length(line_d);
    total_line = total_line + num_line;

    total = num_sig + num_line + num_par;
    total_total = total_total + total;

    sig_percent = 100 * num_sig / total; 

    par_percent = 100 * num_par / total;
    line_percent = 100 * num_line / total;

    percent_bars = [sig_percent par_percent line_percent];

    figure
    bar(percent_bars)
    xticklabels({"sigmoid", "parabola", "misc"})
    ylabel("percent")
    title("functions fit to psychometric data in task: " + story)
    savefig(save_to + "/psych_breakdown_" + story + ".fig")
    close all

    summary = story + " has " + string(sig_percent) + "% sigmoids, " + ...
        string(par_percent) + "% parabolas, and " + string(line_percent) + ...
        "% line psychometric functions. ";

    fin_summary = fin_summary + summary;

end

all_sig = 100 * total_sig / total_total;
all_par = 100 * total_par / total_total;
all_line = 100 * total_line / total_total;

all_summary = "overall, the breakdown is " + string(all_sig) + "% sigmoids, " + ...
        string(all_par) + "% parabolas, and " + string(all_line) + ...
        "% line psychometric functions. the total number of points is " + string(total_total);


figure
percent_bars = [all_sig all_par all_line];
bar(percent_bars)
xticklabels({"sigmoid", "parabola", "misc"})
ylabel("percent")
title("functions fit to psychometric data across all tasks, n = " + total_total)
savefig(save_to + "/psych_breakdown_all.fig")
close all

fin_summary = fin_summary + all_summary;
end
