function plot_space(possible_table, n)

figure
for i = 1:n
    rand_idx = randperm(height(possible_table), 1);
    row = possible_table(rand_idx,:);
    scatter3(row.a, row.b, row.c)
    hold on
end
title("space of coeffs")
end