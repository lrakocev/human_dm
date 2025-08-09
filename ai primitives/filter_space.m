function monotone_table = filter_space(starting_table)

% increasing or decreasing
% no step functions
% only integers

non_step_table = starting_table((starting_table.lvl1 ~= starting_table.lvl2) & (starting_table.lvl3 ~= starting_table.lvl4),:);
monotone_table = non_step_table(non_step_table.lvl4 >= non_step_table.lvl3 >=...
    non_step_table.lvl2 >= non_step_table.lvl1, :);
integer_table = monotone_table(isinteger(monotone_table.lvl1) & isinteger(monotone_table.lvl2) &...
    isinteger(monotone_table.lvl3) & isinteger(monotone_table.lvl4), :);


end