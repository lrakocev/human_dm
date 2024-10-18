function new_table = get_lvl_diffs(sesh_table) 

labels = unique(sesh_table.clusterLabels);
new_table = [];
for i = 1:length(labels)
    label = labels(i);
    label_table = sesh_table(sesh_table.clusterLabels == label, :);
    label_table.cost_psych_types =  repelem(get_c_psych_types(label_table), height(label_table), 1);
    label_table.rew_psych_types = repelem(get_r_psych_types(label_table), height(label_table), 1);
    new_table = [new_table; label_table];
end


end

function diff_types = get_c_psych_types(sesh_table)

shapes = [];
for r = 1:4
    r_table = sesh_table(sesh_table.rew == r, :);
    curr_apprs = r_table.approach_rate;
    if length(curr_apprs) == 4
        type = define_type(curr_apprs');
        shapes = [shapes; type];
    end
end

diff_types = length(unique(shapes));
end

function diff_types = get_r_psych_types(sesh_table)

shapes = [];
for c = 1:4
    c_table = sesh_table(sesh_table.cost == c, :);
    curr_apprs = c_table.approach_rate;
    if length(curr_apprs) == 4
        type = define_type(curr_apprs');
        shapes = [shapes; type];
    end
end

diff_types = length(unique(shapes));
end

function type = define_type(y)

    x = [1 2 3 4];
    [fitobject1, gof1]= fit(x.',y.','a*x+b');
    [fitobject3, gof3] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');
    [fitobject5, gof5] = fit(x.',y.','a*x^2+b*x+c');
    
    max_r = max([gof3.rsquare, gof1.rsquare, gof5.rsquare]);
    
    if max_r == gof3.rsquare 
        type = 3;
    elseif max_r == gof1.rsquare
        type = 1;
    else
        type = 5;
    end

end
