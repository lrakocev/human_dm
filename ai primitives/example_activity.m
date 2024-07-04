% example activity

load("subset_dirk_space.mat")

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\06_10_04";
mkdir(save_to)
num_clusters = 12;
colors = distinguishable_colors(num_clusters);
%[dirk_cluster_data, param_data, index] = clusters_to_configs(myTable, param_table, rand_rows, num_clusters ,colors,'euclidean',save_to);

clusters_of_interest = [11,12];
max_da = 4;
max_lh = 15;
max_strio = 20;
exs = {"cost only","reward only"};

for r = 1:2
    c = clusters_of_interest(r);
    cluster_data = param_data(param_data.cluster == c, :);
    map_type = string(exs(r));

    if map_type == "cost only"
        want_max_lh = 1;
        want_min_da = 1;
    end

    if map_type == "cost only"
        row = cluster_data(cluster_data.LH0 == max_lh & cluster_data.DA_b < max_da, :);
    else
        row = cluster_data(cluster_data.DA_b == max_da & cluster_data.LH0 < max_lh, :);
    end

    if height(row) > 1
        row = row(1,:);
    end

    n_tstep = 100;
    t = linspace(0,2*pi,n_tstep);
    n_ctx = 10;
    da_activity = row.DA_b / max_da;
    strio_activity = row.strio / max_strio;
    lh_activity = row.LH0 / max_lh;
    max_activity = max([da_activity, strio_activity, lh_activity]);
    
    ctx_ews = [1 .5 repelem(.1,n_ctx-2)];
    Sigma = sprandsym(n_ctx,1,ctx_ews); % randomly create a covariance matrix
    [ev,~] = eigs(Sigma);
    
    inc = round(n_tstep/3);
    baseline = -sin(1.5*t)';
    baseline = baseline .* [repelem(0,inc),repelem(1,inc+1),...
        repelem(0,inc)]';
    noise =.2*mvnrnd(zeros(1,n_ctx),Sigma,n_tstep);
    fin = baseline+noise;
    
    x=linspace(0,1,n_tstep);
    figure
    a1 = subplot(3,1,1);
    plot(x,fin(:,1)*strio_activity)
    xlabel("time (arb. u.)")
    ylabel("STRIO activity (arb. u.)")
    title("STRIO activity lvl: " + string(strio_activity))
    a2 = subplot(3,1,2);
    plot(x,fin(:,2)*da_activity)
    xlabel("time (arb. u.)")
    ylabel("DA activity (arb. u.)")
    title("DA activity lvl: " + string(da_activity))
    a3 = subplot(3,1,3);
    plot(x,fin(:,3)*lh_activity)
    xlabel("time (arb. u.)")
    ylabel("LH activity (arb. u.)")
    title("LH activity lvl: " + string(lh_activity))
    sgtitle('example of triple configuration activity for ' + map_type)
    linkaxes([a1 a2 a3])
    set(gcf,'renderer','Painters')
    saveas(gcf,save_to + "/" + map_type + ".fig",'fig')
    saveas(gcf,save_to + "/" + map_type + ".svg",'svg')
end

