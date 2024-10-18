function new_table = get_rat_appr_bias(sesh_table)

new_table = [];
for i = 1:height(sesh_table)
    row = sesh_table(i,:);
    apprs = [row.y4 row.y3 row.y2 row.y1];
    row.mean_appr = mean(apprs, 'omitnan');
    row.max_appr = max(apprs);
    new_table = [new_table; row];
end
end
