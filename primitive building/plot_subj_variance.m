function plot_subj_variance(prim_table, save_to, want_save)

subjects = unique(prim_table.subjectidnumber);

for i = 1:length(subjects)
    s = subjects(i);
    sub_table = prim_table(prim_table.subjectidnumber == s, :);

    avg_psych = get_avg_psych(sub_table);

    diffs = sub_table.diffs_from_sub_avg;
    avg_diffs = abs(mean(diffs));

    x = [1 2 3 4];
    mean_pts = avg_psych([1 2 3 4])';

    above_mean = mean_pts + avg_diffs;
    below_mean = mean_pts - avg_diffs;

    x2 = [x, fliplr(x)];
    inBetween = [above_mean, fliplr(below_mean)];

    figure(i)
    fill(x2, inBetween, [0.3010 0.7450 0.9330]);
    hold on 
    plot(avg_psych)
    hold off

    title("subject " + string(s))
    if want_save
        set(gcf,'renderer','Painters')
        saveas(gcf,save_to+"\sub_" + string(s) + "_var", "fig")
        saveas(gcf,save_to+"\sub_" + string(s) + "_var", "svg")
    end
end

end

