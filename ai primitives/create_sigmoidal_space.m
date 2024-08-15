possible_table = [];

a_arr = -15:0.25:20;
b_arr = -20:0.25:25;
c_arr = -20:0.25; 5;
for a = a_arr
    for b = b_arr
        for c = c_arr
            row.a = a;
            row.b = b;
            row.c = c;
            row.lvl1 = test_sig(1,exp(abs(a)),exp(abs(b)),exp(abs(c)));
            row.lvl2 = test_sig(2,exp(abs(a)),exp(abs(b)),exp(abs(c)));
            row.lvl3 = test_sig(3,exp(abs(a)),exp(abs(b)),exp(abs(c)));
            row.lvl4 = test_sig(4,exp(abs(a)),exp(abs(b)),exp(abs(c)));
            possible_table = [possible_table; row];
        end
    end
end

possible_table = struct2table(possible_table);
filtered_table = possible_table(possible_table.lvl1 >= 0 & possible_table.lvl4 <= 100, :);
further_filter = filtered_table(filtered_table.lvl1 ~= filtered_table.lvl4,:);
save('full space')

function y = test_sig(x, a, b, c)
y = a/(1+b*exp(-c*(x)));
end