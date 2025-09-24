function lvls = get_thresh_lvls(feature_col, num_lvls)

max_val = max(feature_col);
min_val = min(feature_col);

increment = (abs(min_val)+abs(max_val))/num_lvls;
lvls = min_val:increment:max_val;
lvls = lvls(2:end);
end
