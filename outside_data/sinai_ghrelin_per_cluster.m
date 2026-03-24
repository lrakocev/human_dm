function mt_sinai_cluster_table = sinai_ghrelin_per_cluster(cluster_xlsx_file, mt_sinai_trial_table, num_clusters, k01_home_folder, want_sign, save_to)

if isempty(cluster_xlsx_file)
    mt_sinai_trial_table.cluster_idx = repelem(NaN, height(mt_sinai_trial_table), 1);

    if want_sign
        x_coord = log(abs(mt_sinai_trial_table.x_coord)) .* sign(mt_sinai_trial_table.x_coord);
        y_coord = log(abs(mt_sinai_trial_table.y_coord)) .* sign(mt_sinai_trial_table.y_coord);
        z_coord = log(abs(mt_sinai_trial_table.z_coord)) .* sign(mt_sinai_trial_table.z_coord);
    else
        x_coord = log(abs(mt_sinai_trial_table.x_coord));
        y_coord = log(abs(mt_sinai_trial_table.y_coord));
        z_coord = log(abs(mt_sinai_trial_table.z_coord));
   end
    coords = [x_coord, y_coord, z_coord];
    
    opt = fcmOptions(NumClusters = num_clusters);
    [~,U,~,info] = fcm(coords,opt);
    
    mpc = calculate_mpc(U);
    maxU = max(U);
    
    colors = distinguishable_colors(num_clusters);
    
    figure;
    scatters = [];
    mt_sinai_cluster_table = [];
    for j=1:num_clusters
        current_color = colors(j,:);
        indexes = find(U(j,:)==maxU);
    
        idx_rows = mt_sinai_trial_table(indexes, :);
        idx_rows.cluster_idx = repelem(j,height(idx_rows),1);
        mt_sinai_cluster_table = [mt_sinai_cluster_table; idx_rows];
        scatter_object = scatter3(x_coord(indexes, :) ,y_coord(indexes, :), z_coord(indexes, :), [],current_color);
        hold on
        scatters = [scatters; scatter_object];
    
    end
    
    legend(string(1:num_clusters)); 
    xlabel("x coord");
    ylabel("y coord");
    zlabel("z coord")
    title("clustering for mt sinai data, mpc = " + string(mpc) + ", num clusters = " + string(num_clusters))
    savefig(save_to + "\mt_sinai_clusters_with_sign.fig")
else

    mt_sinai_cluster_table = readtable(cluster_xlsx_file);

    mt_sinai_cluster_table.plot_x  = log(abs(mt_sinai_cluster_table.x_coord));
    mt_sinai_cluster_table.plot_y  = log(abs(mt_sinai_cluster_table.y_coord));
    mt_sinai_cluster_table.plot_z = log(abs(mt_sinai_cluster_table.z_coord));

    if want_sign
        mt_sinai_cluster_table.plot_x = mt_sinai_cluster_table.plot_x .* sign(mt_sinai_cluster_table.x_coord);
        mt_sinai_cluster_table.plot_y = mt_sinai_cluster_table.plot_y .* sign(mt_sinai_cluster_table.y_coord);
        mt_sinai_cluster_table.plot_z = mt_sinai_cluster_table.plot_z .* sign(mt_sinai_cluster_table.z_coord);
    end
        

    figure
    hs = [];
    num_clusters = max(mt_sinai_cluster_table.cluster_idx);
    for cluster = 1:num_clusters
        cluster_table = mt_sinai_cluster_table(mt_sinai_cluster_table.cluster_idx == cluster, :);
        h = scatter3(cluster_table.plot_x,cluster_table.plot_y,cluster_table.plot_z);
        hold on
        hs = [hs; h];
    end
    legend(1:num_clusters)
    title("mt sinai clusters")
    hold off
end

ghrelin_table = readtable(k01_home_folder + "/K01_tracking.xlsx","Sheet","ghrelin-updated","NumHeaderLines",0);
ghrelin_table.id = "K" + ghrelin_table.K01_SUBID;

mt_sinai_hormone_table = outerjoin(mt_sinai_cluster_table, ghrelin_table, "MergeKeys", 1, "Keys", {'id'});
mt_sinai_hormone_table = mt_sinai_hormone_table(~isnan(mt_sinai_hormone_table.x_coord), :);

p_ghr_both_sex = anova1(mt_sinai_hormone_table.aGHR, mt_sinai_hormone_table.cluster_idx);

p_ghr_with_sex = anovan(mt_sinai_hormone_table.aGHR, {mt_sinai_hormone_table.cluster_idx;mt_sinai_hormone_table.Sex}, "varnames",["cluster","sex"]);

combos = nchoosek(1:num_clusters, 2);
ttest_all_ghr_ps = [];
for t = 1:length(combos)
    combo = combos(t,:);
    col1 = mt_sinai_hormone_table(mt_sinai_hormone_table.cluster_idx == combo(1),:).aGHR;
    col2 = mt_sinai_hormone_table(mt_sinai_hormone_table.cluster_idx == combo(2),:).aGHR;
    [h,ttest_p_ghr] = ttest2(col1, col2,'Vartype','unequal');
    ttest_all_ghr_ps = [ttest_all_ghr_ps; ttest_p_ghr];
end



sexes = unique(mt_sinai_hormone_table.Sex);
for s = 1:length(sexes)
    sex = string(sexes(s));

    num_bars = [];

    bars_ghr = [];
    stds_ghr = [];
    
    bars_estr = [];
    stds_estr = [];
    
    bars_test = [];
    stds_test = [];

    sex_table = mt_sinai_hormone_table(mt_sinai_hormone_table.Sex == sex, :);

    ttest_sex_ghr_ps = [];
    ttest_sex_estr_ps = [];
    ttest_sex_testos_ps = [];
    for m = 1:length(combos)
        combo = combos(m,:);
        col1 = mt_sinai_hormone_table(sex_table.cluster_idx == combo(1),:);
        col2 = mt_sinai_hormone_table(sex_table.cluster_idx == combo(2),:);
        [h,ttest_p_ghr] = ttest2(col1.aGHR, col2.aGHR, 'Vartype','unequal');
        ttest_sex_ghr_ps = [ttest_sex_ghr_ps; ttest_p_ghr];

        [h,ttest_p_estr] = ttest2(col1.Estradiol_pg_mL_, col2.Estradiol_pg_mL_, 'Vartype','unequal');
        ttest_sex_estr_ps = [ttest_sex_estr_ps; ttest_p_estr];

        [h,ttest_p_testos] = ttest2(col1.TotalTestos_ng_dL_, col2.TotalTestos_ng_dL_,  'Vartype','unequal');
        ttest_sex_testos_ps = [ttest_sex_testos_ps; ttest_p_testos];
    end

    for k = 1:num_clusters
        cluster_table = sex_table(sex_table.cluster_idx == k, :);
        mean_ghr = mean(cluster_table.aGHR, 'omitnan');
        std_err_ghr = std(cluster_table.aGHR, 'omitnan') / sqrt(height(cluster_table(~isnan(cluster_table.aGHR),:)));
    
        num_participants = length(unique(cluster_table.id));
        num_bars = [num_bars; num_participants];

        bars_ghr = [bars_ghr; mean_ghr];
        stds_ghr = [stds_ghr; std_err_ghr];
    
        mean_estr = mean(cluster_table.Estradiol_pg_mL_, 'omitnan');
        std_err_estr = std(cluster_table.Estradiol_pg_mL_, 'omitnan') / sqrt(height(cluster_table(~isnan(cluster_table.Estradiol_pg_mL_),:)));
    
        bars_estr = [bars_estr; mean_estr];
        stds_estr = [stds_estr; std_err_estr];
    
        mean_test = mean(cluster_table.TotalTestos_ng_dL_, 'omitnan');
        std_err_test = std(cluster_table.TotalTestos_ng_dL_, 'omitnan') / sqrt(height(cluster_table(~isnan(cluster_table.TotalTestos_ng_dL_),:)));
    
        bars_test = [bars_test; mean_test];
        stds_test = [stds_test; std_err_test];
    end

    try

    cell_groups = num2cell(combos,2);

    figure
    bar(1:num_clusters, num_bars)
    xlabel("behavioral clusters")
    ylabel("# participants")

    title("# participants for clusters for sex: " + sex)
    set(gcf,'renderer','Painters')
    savefig(save_to + "\" + sex + "_num_participants_per_cluster.fig")
    saveas(gcf,save_to + "\" + sex + "_num_participants_per_cluster","svg")
    
    hold off


    figure
    bar(1:num_clusters, bars_ghr)
    hold on
    errorbar(bars_ghr,stds_ghr)
    xlabel("behavioral clusters")
    ylabel("ghr levels")

    hold on
    sigstar(cell_groups, ttest_sex_ghr_ps);

    title("ghr lvls across clusters for sex: " + sex)
    set(gcf,'renderer','Painters')
    savefig(save_to +"\" +  sex + "_ghr_per_cluster.fig")
    saveas(gcf,save_to +"\" +  sex + "_ghr_per_cluster","svg")



    hold off

    
    figure
    bar(1:num_clusters, bars_estr)
    hold on
    errorbar(bars_estr,stds_estr)
    xlabel("behavioral clusters")
    ylabel("estr levels")

    hold on
    sigstar(cell_groups, ttest_sex_estr_ps);

    title("estrogen lvls across clusters for sex: " + sex)
    set(gcf,'renderer','Painters')
    savefig(save_to + "\" + sex + "_estr_per_cluster.fig")
    saveas(gcf,save_to + "\" + sex + "_estr_per_cluster","svg")

    hold off
    
    figure
    bar(1:num_clusters, bars_test)
    hold on
    errorbar(bars_test,stds_test)
    xlabel("behavioral clusters")
    ylabel("testosterone levels")

    hold on
    sigstar(cell_groups, ttest_sex_testos_ps);

    title("testosterone lvls across clusters for sex: " + sex)
    set(gcf,'renderer','Painters')
    savefig(save_to + "\" + sex + "_test_per_cluster.fig")
    saveas(gcf,save_to + "\" + sex + "_test_per_cluster","svg")
    hold off


    catch
        continue
    end
end

end