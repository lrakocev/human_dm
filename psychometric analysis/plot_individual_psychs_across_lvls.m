function plot_individual_psychs_across_lvls(approach_data, constant, story_type, path_to_save)
    function  best_fit_obj = createSigmoidFigures(results,lvl,constant)
        if isequal(constant,"cost")
            constant_table = results(results.cost == lvl,:);
            x = constant_table.rew.';
        else
            constant_table = results(results.rew == lvl,:);
            x = constant_table.cost.';
        end
        y = constant_table.approach_rate.';
        subid = constant_table.subjectidnumber(1);

        [fitobject1, gof1]= fit(x.',y.','a*x+b');
 
        [fitobject2, gof2] = fit(x.', y.', '1 / (1 + (b*exp(-c * x)))');

        [fitobject3, gof3] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');

        [fitobject4, gof4] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');

        [fitobject5, gof5] = fit(x.',y.','a*(x-b)^(2)+c');

        fit_objects = {fitobject1, fitobject2, fitobject3, fitobject4, fitobject5};
        r_squares =  [gof1.rsquare, gof2.rsquare, gof3.rsquare, gof4.rsquare, gof5.rsquare];
        highest_r_sq = max(r_squares);

        best_fit_ind = find(r_squares == highest_r_sq);
        best_fit_obj = fit_objects{best_fit_ind};

    end

dynamicName = path_to_save + "individual_overlays\" + story_type + "\";
mkdir(dynamicName)
    
N = length(approach_data);
colors = ['r', 'b', 'g', 'c'];
for i = 1:N
    results = approach_data(i);
    if ~isempty(results{1})
        idnum = string(results{1}.subjectidnumber(1));
        story_num = string(results{1}.story_num(1));
        figure
        for c = 1:4
            try
                best_fit_obj = createSigmoidFigures(results{1},c, constant);
                plot(best_fit_obj, colors(c))
            catch
            end
            hold on
        end
        legend(['lvl 1';'lvl 2';'lvl 3';'lvl 4'])
        title('subject id: ' + idnum + constant + ' constant curves, # trials = 16, # sessions = 1')
        fighandle = gcf;

        filename = strcat(dynamicName,idnum,"_",story_type,"_",story_num,"_",constant,".fig");
        
        saveas(fighandle,filename)
        close all 
    end
              
end

end