function dim =  get_map_dim(sesh_data, diff_thresh)

rlvl1 = sesh_data(sesh_data.rew == 1, :).approach_rate;
rlvl2 = sesh_data(sesh_data.rew == 2, :).approach_rate;
rlvl3 = sesh_data(sesh_data.rew == 3, :).approach_rate;
rlvl4 = sesh_data(sesh_data.rew == 4, :).approach_rate;

clvl1 = sesh_data(sesh_data.cost == 1, :).approach_rate;
clvl2 = sesh_data(sesh_data.cost == 2, :).approach_rate;
clvl3 = sesh_data(sesh_data.cost == 3, :).approach_rate;
clvl4 = sesh_data(sesh_data.cost == 4, :).approach_rate;

[r_works, r_means] = check_diffs("rew",rlvl1, rlvl2, rlvl3, rlvl4, diff_thresh);
[c_works, c_means] = check_diffs("cost",clvl1, clvl2, clvl3, clvl4, diff_thresh);

dim = 0;
if r_works && c_works
    dim = 2;
elseif r_works || c_works
    dim = 1;
end


end

function [dim_works, means] = check_diffs(type, lvl1, lvl2, lvl3, lvl4, diff_thresh)

mean_1 = mean(lvl1);
mean_2 = mean(lvl2);
mean_3 = mean(lvl3);
mean_4 = mean(lvl4);
means = [mean_1 mean_2 mean_3 mean_4];
diffs = diff(means);

mean_diff = mean(diffs);
dim_works = 0;
if type == "rew" && all(diffs >= 0) && mean_diff >= diff_thresh
    dim_works = 1;
elseif type == "cost" && all(diffs <= 0) && abs(mean_diff) >= diff_thresh
    dim_works = 1;
end

end

