original = 1;

all_possible_pt1 = readtable("sigmoids_by_10s_excel_file1.xlsx","NumHeaderLines",0);
all_possible_pt2 = readtable("sigmoids_by_10s_excel_file2.xlsx","NumHeaderLines",0);

all_possible = [all_possible_pt1;all_possible_pt2];
good_fit = all_possible(all_possible.rsq > 0.4, :);

to_plot = all_possible;

rand_idx = 1:2:height(to_plot);%randi(height(to_plot),1,10000)';

rand_selection = to_plot(rand_idx,:);

if original
    x_coords = log(abs(rand_selection.a));
    y_coords = log(abs(rand_selection.b));
    z_coords = log(abs(rand_selection.c));
    title_str = "no minimum r-sq, original";
else
    x_coords = log(abs(rand_selection.a)) .* sign(rand_selection.a);
    y_coords = log(abs(rand_selection.b)) .* sign(rand_selection.b);
    z_coords = log(abs(rand_selection.c)) .* sign(rand_selection.c);
    title_str = "no minimum r-sq, with sign";
end

figure
scatter3(x_coords,y_coords,z_coords)
title(title_str)
%title("minimum of r-sq = 0.4")
xlabel("x")
ylabel("y")
zlabel("z")

hold on
if original
    cluster_table = readtable("C:\Users\lrako\OneDrive\Documents\human_dm\dec_2025\all_clusters_original.xlsx");
else
    cluster_table = readtable("C:\Users\lrako\OneDrive\Documents\human_dm\dec_2025\all_clusters_with_sign.xlsx");
end

real_x = cluster_table.clusterX;
real_y = cluster_table.clusterY;
real_z = cluster_table.clusterZ;
scatter3(real_x, real_y, real_z,'r','x')
xlabel("x")
ylabel("y")
zlabel("z")