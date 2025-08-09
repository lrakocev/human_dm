function new_table = get_rat_impulsivity(sesh_table)

new_table = [];
for i = 1:height(sesh_table)
    row = sesh_table(i,:);

    apprs = [row.y4 row.y3 row.y2 row.y1];
    monotonic = all(diff(apprs) > -.2);
    changes = ischange(apprs); 
    impulse = check_imp(changes) & monotonic;

    row.r_impulse = impulse;
    new_table = [new_table; row];
end
end


function impulse = check_imp(changes)
if sum(changes) > 2
    impulse = 0;
else
    impulse = 1;
end
end


