%% decision trees for cluster idx

%load("prim_table.mat");

all_features = ["r_interact","cluster_mse", "r_impulse","mean_appr"];

% , "mse", ...
%    "hunger", "tiredness", "pain", "story_prefs"

node_vars = ["idx" "auto_cluster"];
for i = 1:length(node_vars)
    node_var = node_vars(i);
    [Mdl] = create_decision_tree(prim_table, all_features, node_var, 0, 1);
end
