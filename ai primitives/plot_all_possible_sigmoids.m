all_possible = readtable("sigmoid_excel_file1.xlsx","NumHeaderLines",0);
good_fit = all_possible(all_possible.rsq > 0.4, :);

to_plot = all_possible;

rand_idx = randi(height(to_plot),1,10000)';

rand_selection = to_plot(rand_idx,:);

x_coords = log(abs(rand_selection.a));
y_coords = log(abs(rand_selection.b));
z_coords = log(abs(rand_selection.c));

figure
scatter3(x_coords,y_coords,z_coords)
title("no minimum r-sq")
%title("minimum of r-sq = 0.4")