function new_table = get_rat_randomness(sesh_table)

new_table = [];
for i = 1:height(sesh_table)
    row = sesh_table(i,:);
    row.mse = get_mse(row);
    new_table = [new_table; row];
end

end

function mse = get_mse(row)

xs = [1,2,3,4];
ys =  [row.y4 row.y3 row.y2 row.y1];

a = (row.rawX);
b = (row.rawY);
c = (row.rawZ);

sigmoid = @(x) (a/(1+b*exp(-c*(x))));
sig_fit = arrayfun(sigmoid,xs);
mse = sum((sig_fit-ys).^2)/length(ys);

end