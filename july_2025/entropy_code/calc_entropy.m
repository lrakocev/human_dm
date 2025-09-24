function entropy = calc_entropy(vals)

entropy = 0;
for i = 1:length(vals)
    val = vals(i);
    if ~isnan(val) & val~=0
        entropy = entropy + val*log(val);
    end
end

entropy = -entropy;

end
