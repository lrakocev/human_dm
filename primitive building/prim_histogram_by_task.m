function means = prim_histogram_by_task(prim_table, hum_or_rat, feat_name, want_save, save_to)

means = [];
serrs = [];
stories = unique(prim_table.story_type);
for i = 1:length(stories)
    story = stories(i);
    story_table = prim_table(prim_table.story_type == story, :);

    if feat_name == "mean appr"
        data = story_table.mean_appr;
    elseif feat_name == "max appr"
        data = story_table.max_appr;
    elseif feat_name == "med appr"
        data = story_table.med_appr;
    elseif feat_name == "reward interact"
        data = story_table.r_interact;
    elseif feat_name == "cost interact"
        data = story_table.c_interact;
    elseif feat_name == "reward impulse"
        data = story_table.r_impulse;
    elseif feat_name == "cost impulse"
        data = story_table.c_impulse;
    elseif feat_name == "subj var"
        data = story_table.subj_var;
    end

    [curr_mean, curr_serr] = get_summary(data);
    
    means = [means; curr_mean];
    serrs = [serrs; curr_serr];


end

if feat_name == "valuation"
    feat_name = "valuation (aka shift)";
elseif feat_name == "elasticity"
    feat_name = "elasticity (aka slope)";
end
plot_data(stories,means, serrs, hum_or_rat + " " + feat_name, want_save, save_to)

end

function [means, serrs] = get_summary(data)

non_nan = data(~isnan(data));
means = mean(non_nan, 'omitnan');
% div by 16 because of the overcounting due to each lvl in the session
serrs = std(non_nan, 'omitnan') / sqrt(length(non_nan) / 16 );

end

function plot_data(unique_tasks,mean_dat, serr_dat, feat_name, want_save, save_to)

figure
bar(unique_tasks,mean_dat)
hold on
errorbar(1:length(unique_tasks),mean_dat, serr_dat)
xlabel("cluster number")
ylabel(feat_name)
title(feat_name + " for psychs in cluster")
if want_save
set(gcf,'renderer','Painters')
saveas(gcf,save_to + "\" + feat_name, "fig")
saveas(gcf,save_to + "\" + feat_name, "svg")
end

end