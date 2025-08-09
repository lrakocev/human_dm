function sig_table = get_2d_sig_fit(approach_data,story_type)

sig_table = [];
N = length(approach_data);
cost_levels = 1/4:1/4:1;
reward_levels = 1/4:1/4:1;

rs = repelem(reward_levels,1,length(reward_levels))'; %repeat the reward levels array 4 times (1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4)
cs = repmat(cost_levels,1,length(cost_levels))'; %repeat the cost_levels array 4 times (1 2 3 4 1 2 3 4 1 2 3 4 1 2 3 4)
    
for i = 1:N
    results = approach_data(i);
    results = results{1};
    if ~isempty(results)
        
        y = [];
        for r = 1:4
            curr = results(results.rew == r, :);
            appr_rate = mean(curr.approach_rate, 'omitnan');
            y = [y; appr_rate];
        end
 
        % not necessary for this but it's the filter we used for og fitting
        if length(y) >= 4 && all(~isnan(y))
            i = 1;
            for r=1:length(reward_levels)
                for c=1:length(cost_levels)
                    curr_row = results(results.cost == c & results.rew == r,:);
                    if ~isempty(curr_row)
                        ps(i) = mean(curr_row.approach_rate,'omitnan');
                    else
                        ps(i) = NaN;
                    end
                    i = i+1;
                end
            end
    
            ps = fillmissing(ps,'linear');%fill in any missing values with the mean of the rest
            ps = ps/100; %make the approach percentages in a decimal instead of a whole number
    
           if anynan(ps)
                continue
            end
           
            subid = results.subjectidnumber(1);
            story_num = results.story_num(1);
    
    
            syms R C %just variables to be solved for later on, x and y values 
            
            g = fittype( @(a_R,b_R,a_C,b_C,R,C) 1./(1+exp(-a_R.*R+b_R))*1./(1+exp(a_C.*C+b_C)), ...
                'coefficients', {'a_R','b_R','a_C','b_C'}, 'independent', {'R', 'C'}, ...
                'dependent', 'z' );
        
            % Call fit and specify the value of c.
    
            f = fit([rs, cs], ps', g, 'StartPoint', [1; 0; 1; 0]); 
            
            row.subjectidnumber = subid;
            row.story_num = story_num;
            row.experiment = story_type;
            
            row.a_R = f.a_R;
            row.b_R = f.b_R;
            row.a_C = f.a_C;
            row.b_C = f.b_C;
          
    
            sig_table = [sig_table; row];
            
        else
            continue
        end        
    end
end

sig_table = struct2table(sig_table);

end