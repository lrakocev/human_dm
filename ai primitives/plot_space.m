function plot_space(possible_table)

figure
for i = 1:height(possible_table)
    row = possible_table(i,:);
    scatter3(row.a, row.b, row.c)
    hold on
end