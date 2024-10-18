function plot_psych(sig_table,tit,want_save,save_to)

lvl_1 = sig_table(sig_table.rew == 1, :).approach_rate;
lvl_2 = sig_table(sig_table.rew == 2, :).approach_rate;
lvl_3 = sig_table(sig_table.rew == 3, :).approach_rate;
lvl_4 = sig_table(sig_table.rew == 4, :).approach_rate;

mean_lvl_1 = mean(lvl_1, 'omitnan');
mean_lvl_2 = mean(lvl_2, 'omitnan');
mean_lvl_3 = mean(lvl_3, 'omitnan');
mean_lvl_4 = mean(lvl_4, 'omitnan');


a = sig_table.rawX(1);
b = sig_table.rawY(1);
c = sig_table.rawZ(1);

figure
fplot(@(x) (a/(1+b*exp(-c*(x)))))
hold on
scatter(1:4,[mean_lvl_1 mean_lvl_2 mean_lvl_3 mean_lvl_4])
title(tit)
hold off

if want_save
    set(gcf,'renderer','Painters')
    saveas(gcf, save_to + "\" + tit, "fig")
    saveas(gcf, save_to + "\" + tit, "svg")
end