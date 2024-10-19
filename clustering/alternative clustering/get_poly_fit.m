function poly_table = get_poly_fit(approach_data,story_type)

poly_table = [];
N = length(approach_data);
for i = 1:N
    results = approach_data(i);
    results = results{1};
    if ~isempty(results)
        x = unique(results.rew)';
       
        y = [];
        for r = 1:length(x)
            curr = results(results.rew == r, :);
            appr_rate = mean(curr.approach_rate, 'omitnan');
            y = [y; appr_rate];
        end

        y = y';

        if length(y) >= 4 && all(~isnan(y))
        
            subid = results.subjectidnumber(1);
            story_num = results.story_num(1);

            p = polyfit(x.', y.', 3);

            f = polyval(p,x);

            row.subjectidnumber = subid;
            row.story_num = story_num;
            row.experiment = story_type;
            row.a = p(1);
            row.b = p(2);
            row.c = p(3);
            row.d = p(4);
            row.err = sum((y - f).^2)/4;

            poly_table = [poly_table; row];
        end
    end
end

poly_table = struct2table(poly_table);

end