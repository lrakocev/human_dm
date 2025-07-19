function fit_pig(approach_data, dirName, sig_type, thresh)
    function[] = pig_helper(results, c, dirName, sig_type)
        if ~isempty(results)
            if sig_type == "cost" 
                constant_lvl = results(results.cost == c,:);
                x = constant_lvl.rew.';
            else
                constant_lvl = results(results.rew == c,:);
                x = constant_lvl.cost.';
            end

            story_pref = results.story_prefs(1);
            y = constant_lvl.approach_rate.';
        
            if length(y) >= 4 && all(~isnan(y))
                subid = constant_lvl.subjectidnumber(1);
                story_num = constant_lvl.story_num(1);
        
    
                counter = 1;
                cannon_eq = "1/(1+exp(a*(b*x - c*" + string(c) + ")))";
                [fitobject1, gof1] = fit(x.', y.', cannon_eq);
                while counter <20 && gof1.rsquare < .4
                    [fitobject1, gof1] = fit(x.', y.', cannon_eq);
                    counter = counter+1;
                end

                counter = 1;
                new_eq = "1/(1+exp([a + d *" + story_pref + " ] * (b*x - c* " + string(c) + ")))";
                [fitobject2, gof2] = fit(x.', y.', new_eq);
                while counter <20 && gof2.rsquare < .4
                    [fitobject2, gof2] = fit(x.', y.', new_eq);
                    counter = counter+1;
                end
    
                save(strcat(dirName,'cannon\',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'fitobject1') 
                save(strcat(dirName,'pig\',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'fitobject2') 
                

                save(strcat(dirName,'cannon_r\',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'gof1') 
                save(strcat(dirName,'pig_r\',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'gof2') 
                 
            end
            close all
    end
end

          
N = length(approach_data);
for i = 1:N
    results = approach_data{i};
    maxc = max(results.cost);
    for c = 1:maxc
        pig_helper(results, c, dirName, sig_type)
    end
end

end