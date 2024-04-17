function plot_activity_from_dim(cond_probs, dim, strio_activity, lh_activity, da_activity)


strio_activity_for_dim = strio_activity{dim+1};
lh_activity_for_dim = lh_activity{dim+1};
da_activity_for_dim = da_activity{dim+1};


max_strio = max(strio_activity_for_dim);
min_strio = min(strio_activity_for_dim);
max_lh = max(lh_activity_for_dim);
min_lh = min(lh_activity_for_dim);
max_da = max(da_activity_for_dim);
min_da = min(da_activity_for_dim);

% to indicate the full possible space
figure
for j = min_strio:max_strio
    for k = min_lh:max_lh
        for l = min_da:max_da
            scatter3(j,k,l,1,'b')
            hold on
        end
    end
end


for i = 1:length(cond_probs)
    scatter3(strio_activity_for_dim(i),lh_activity_for_dim(i),da_activity_for_dim(i),1000*cond_probs(i),'filled','o','r')
    hold on
end
xlabel("sSPN activity (arb. u.)")
ylabel("LHb activity (arb. u.)")
zlabel("DA of SNc activity (arb. u.)")
title("Likelihood of circuit configuration for map w/ dim = " + string(dim));
subtitle("size = probability of having that configuration")

end
