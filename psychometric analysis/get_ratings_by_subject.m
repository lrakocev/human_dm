function get_ratings_by_subject(r_ratings,c_ratings,type,save_to,same_scale)

    xs = 1:4;
    curr_r_ratings = r_ratings(r_ratings.tasktype == type, :);
    curr_c_ratings = c_ratings(c_ratings.tasktype == type, :);

    unique_ids = unique(curr_r_ratings.subid);

    mean_rs = [];
    mean_cs = [];
    for i = 1:length(unique_ids)
        id = unique_ids(i); 
        id_r_ratings = curr_r_ratings(curr_r_ratings.subid == string(id),:);
        id_c_ratings = curr_c_ratings(curr_c_ratings.subid == string(id),:);

        id_r_ratings = id_r_ratings(:,1:4);
        id_c_ratings = id_c_ratings(:,1:4);

        id_mean_r = table2array(mean(id_r_ratings));
        id_mean_c = table2array(mean(id_c_ratings));

        mean_rs = [mean_rs; id_mean_r];
        mean_cs = [mean_cs; id_mean_c];

    end

    lvl1 = ones(length(mean_rs),1);
    x_coords = [lvl1; lvl1*2; lvl1*3; lvl1*4];
    y_coords_r = [mean_rs(:,1); mean_rs(:,2); mean_rs(:,3); mean_rs(:,4)];
  
    mean_r = mean(mean_rs,'omitnan');
    mean_c = mean(mean_cs,'omitnan');

    std_err_r = std(mean_rs) / length(mean_rs);
    std_err_c = std(mean_cs) / length(mean_cs);

    figure
    mdl_r = fitlm(x_coords, y_coords_r);
    plot(mdl_r)
    r_sq_r = mdl_r.Rsquared.ordinary;
    xlabel("levels")
    ylabel("rating")
    title(type + " reward for n = " + string(length(mean_rs)) + " subjects")
    subtitle("R-squared (ordinary): " + string(r_sq_r))
    figname1 = save_to + type + "_" + "_lin_reg_reward_ratings_by_subj.fig";
    savefig(figname1)

    y_coords_c = [mean_cs(:,4); mean_cs(:,3); mean_cs(:,2); mean_cs(:,1)];
    mdl_c = fitlm(x_coords, y_coords_c);
    plot(mdl_c)
    r_sq_c = mdl_c.Rsquared.ordinary;
    xlabel("levels")
    ylabel("rating")
    title(type + " reward for n = " + string(length(mean_rs)) + " subjects")
    subtitle("R-squared: " + string(r_sq_c))
    figname2 = save_to + type + "_" + "_lin_reg_cost_ratings_by_subj.fig";
    savefig(figname2)

    figure
    errorbar(xs, mean_r, std_err_r, std_err_r)
    xlabel("levels")
    ylabel("rating")
    title(type + " reward for n = " + string(length(mean_rs)) + " subjects")
    figname3 = save_to + type + "_" + "reward_ratings_by_subj.fig";
    if same_scale
        ylim([20 100])
        figname3 = save_to + type + "_" + "reward_ratings_scaled_by_subj.fig";
    end
    savefig(figname3)
    
    figure
    errorbar(xs, flip(mean_c), flip(std_err_c), flip(std_err_c))
    xlabel("levels")
    ylabel("rating")
    title(type + " cost for n = " + string(length(mean_cs)) + " subjects")
    figname4 = save_to + type + "_" + "cost_ratings_by_subj.fig";
    if same_scale
        ylim([20 100])
        figname4 = save_to + type + "_" + "cost_ratings_scaled_by_subj.fig";
    end
    savefig(figname4)
    close all 


end