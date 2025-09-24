function feature_data = group_by_feature(approach_data, feature)

feature_data = {};
unique_vals = unique(approach_data.(feature));
for i = 1:length(unique_vals)
    val = string(unique_vals(i));
    value_table = approach_data(string(approach_data.(feature)) == val, :);
    feature_data{i} = value_table;
end

end