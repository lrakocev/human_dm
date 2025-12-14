function [state_funcs,types] = create_1d_state_psychs(state_table,state_var,fit_type,want_plot)

try
    unique_states = unique(state_table.(state_var));
catch
    state_funcs = [];
    types = [];
    return
end
state_funcs = {};
types = {};
y_min = 100;
y_max = 0;
figure
for i = 1:length(unique_states)
    state = unique_states(i);
    curr_state_table = state_table(state_table.(state_var) == state, :);

    lvl_1 = curr_state_table(curr_state_table.rew == 1, :).approach_rate;
    lvl_2 = curr_state_table(curr_state_table.rew == 2, :).approach_rate;
    lvl_3 = curr_state_table(curr_state_table.rew == 3, :).approach_rate;
    lvl_4 = curr_state_table(curr_state_table.rew == 4, :).approach_rate;

    mean_lvl_1 = mean(lvl_1, 'omitnan');
    mean_lvl_2 = mean(lvl_2, 'omitnan');
    mean_lvl_3 = mean(lvl_3, 'omitnan');
    mean_lvl_4 = mean(lvl_4, 'omitnan');

    x = [1,2,3,4];
    y = [mean_lvl_1, mean_lvl_2, mean_lvl_3, mean_lvl_4];

    if fit_type == "mixed"

         [func, gof1] = fit(x.',y.','a*[(m/(1+n*exp(-o*(x))))] + b*[p*(x-q)^(2)+r] + c*[s*x+t]');
            counter = 0;
            while counter < 20 && gof1.rsquare < .7
                [func, gof1] = fit(x.',y.','a*[(m/(1+n*exp(-o*(x))))] + b*[p*(x-q)^(2)+r] + c*[s*x+t]');
                counter = counter+1;
            end 
        
            type = "mixed";
        

    elseif fit_type == "poly"
        if ~any(isnan(y))
            
            [func, gof1] = fit(x.',y.','a*x^3 + b*x^2 + c*x + d');
            counter = 0;
            while counter < 20 && gof1.rsquare < .7
                [func, gof1] = fit(x.',y.','a*x^3 + b*x^2 + c*x + d');
                counter = counter+1;
            end 
        
            %func = polyfit(x.', y.', 3);
            type = "poly";
        else
            return
        end
    else
        counter = 0;
        [sigmoid_func, gof_sig] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');
        while counter < 20 && gof_sig.rsquare < .7
            [sigmoid_func, gof_sig] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');
            counter = counter+1;
        end 
    
        counter = 0;
        [parabolic_func, gof_parab] = fit(x.',y.','a*(x-b)^(2)+c');
        while counter < 20 && gof_parab.rsquare < .7
            [parabolic_func, gof_parab] = fit(x.',y.','a*(x-b)^(2)+c');
            counter = counter+1;
        end 
    
        if gof_parab.rsquare > gof_sig.rsquare
            func = parabolic_func;
            type = "parabola";
        else
            func = sigmoid_func;
            type = "sigmoid";
        end

    end
   
    if want_plot
        ax(i) = subplot(1,length(unique_states),i);

        if fit_type == "poly2"
            fplot(poly2sym(func),[min(x) max(x)])
            hold on 
            scatter(x.',y.')
        else
            plot(func, x.', y.')   
        end
        
        yl = get(gca, 'YLim');
        curr_y_min = yl(1);
        curr_y_max = yl(2);
        if curr_y_min < y_min 
            y_min = curr_y_min;
        end
        if curr_y_max > y_max
            y_max = curr_y_max;
        end
        title('psych for state ' + string(i))
    end
   
    state_funcs{i} = func;
    types{i} = type;
end


end