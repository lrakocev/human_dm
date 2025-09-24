function feature_data = group_by_continuous_feature(approach_data, feature)

thresholds = [0 33 66 100];
lvls = {'lo','mid','hi'};
approach_data.group = discretize(approach_data.(feature), thresholds, 'categorical', {'lo','mid','hi'});

feature_data = {};
for i = 1:3
    lvl = lvls{i};
    feature_data{i} = approach_data(approach_data.group ==lvl, :);
end

end