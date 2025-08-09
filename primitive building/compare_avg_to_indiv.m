function [mse, diffs] = compare_avg_to_indiv(avg_psych, sig_table)

xs = [1,2,3,4];

% should all be the same function bc same label
a = (sig_table.rawX(1));
b = (sig_table.rawY(1));
c = (sig_table.rawZ(1));
sigmoid = @(x) (a/(1+b*exp(-c*(x))));
sig_fit = arrayfun(sigmoid,xs);

avg_fit = avg_psych(xs)';

diffs = avg_fit - sig_fit;
mse = sum((diffs).^2)/length(xs);

end