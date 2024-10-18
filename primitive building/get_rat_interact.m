function new_table = get_rat_interact(sesh_table)

new_table = [];
for i = 1:height(sesh_table)
    row = sesh_table(i,:);

    apprs = [row.y4 row.y3 row.y2 row.y1];
    diffs = diff(apprs);
    med_diff = median(diffs);
  
    row.r_interact = med_diff;
    new_table = [new_table; row];
end
end
