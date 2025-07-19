function fit_pig(approach_data, dirName, sig_type, thresh)
    function[] = pig_helper(results, c, thresh, dirName, sig_type)
        if ~isempty(results)
            if sig_type == "cost" 
                constant_lvl = results(results.cost == c,:);
                x = constant_lvl.rew.';
            else
                constant_lvl = results(results.rew == c,:);
                x = constant_lvl.cost.';
            end
            y = constant_lvl.approach_rate.';
        
            if length(y) >= 4 && all(~isnan(y))
                subid = constant_lvl.subjectidnumber(1);
                story_num = constant_lvl.story_num(1);
        
    
                counter = 1;
                [fitobject1, gof1] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');
                while counter <20 && gof1.rsquare < .4
                    [fitobject1, gof1] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');
                    counter = counter+1;
                end

                counter = 1;
                [fitobject2, gof2] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');
                while counter <20 && gof2.rsquare < .4
                    [fitobject2, gof2] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');
                    counter = counter+1;
                end
    
                save(strcat(dirName,'canon\',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'fitobject1') 
                save(strcat(dirName,'PIG\',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'fitobject2') 

                                  
            end
            close all
        end
    end
end
          
N = length(approach_data);
for i = 1:N
    results = approach_data{i};
    maxc = max(results.cost);
    for c = 1:maxc
        createSigmoidFigures(results, c, thresh, dirName, sig_type)
    end
end

end