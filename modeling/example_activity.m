% example activity

home_dir = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\modeling\";
load(home_dir + "triplets");
rows = [2,5,7,16];
exs = {"disordered","reward only", "cost only", "integrated"};

for r = 1:4
    row_num = rows(r);
    map_type = string(exs(r));
    row = triplets(row_num,:);
    n_tstep = 100;
    t = linspace(0,2*pi,n_tstep);
    n_ctx = 10;
    dim = row.dim;
    da_activity = lower_bound(row.da);
    strio_activity = lower_bound(row.strio);
    lh_activity = lower_bound(row.lh);
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
    sgtitle('example of triple configuration activity for ' + map_type + ' map w/ dim ' + string(dim))
    linkaxes([a1 a2 a3])
    savefig(home_dir + map_type + ".fig")
end

function activity = lower_bound(activity)

if activity == 0
    activity = 0.15;
end
end
