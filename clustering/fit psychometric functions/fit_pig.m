function fit_pig(approach_data, dirName, sig_type, thresh)
    function[] = pig_helper(results, c, dirName, sig_type)
        if ~isempty(results)

            if sig_type == "cost"
                results = sortrows(results, "rew");
                constant_lvl = results(results.cost == c,:);
                x = constant_lvl.rew.';
            else
                results = sortrows(results, "cost");
                constant_lvl = results(results.rew == c,:);
                x = constant_lvl.cost.';
            end

            story_pref = results.story_prefs(1)/100;
            y = constant_lvl.approach_rate.';

            pupil_diam = mean(results.pupil_diameter, 'omitnan');
        
            if length(y) >= 4 && all(~isnan(y))
                subid = constant_lvl.subjectidnumber(1);
                story_num = constant_lvl.story_num(1);        
                
                f1 = @(b,x) 100./(1+exp(-b(1).*(b(2).*x - b(3).*c)));
                mdl1 = fit_model(x, y, f1, [1,1,1]);

                f2 = @(b,x) 100./(1+exp(-(b(1) + b(4) .* story_pref) .* (b(2).*x - b(3)*c)));
                mdl2 = fit_model(x, y, f2, [1,1,1,1]);
                                
                f3 = @(b,x) 100./(1+exp(-(b(1) + b(4)*pupil_diam) .* (b(2).*x - b(3)*c)));
                mdl3 = fit_model(x, y, f3, [1,1,1,1]);

                save(strcat(dirName,'cannon/',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'mdl1') 
                save(strcat(dirName,'relevance_pig/',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'mdl2') 
                save(strcat(dirName,'pupil_pig/',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'mdl3') 

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

function mdl = fit_model(x, y, func_def, starting)

counter = 1;
try
    mdl = fitnlm(x.', y.', func_def, starting);
catch
    mdl = 0;
    return
end
while counter < 20 && mdl.Rsquared.Ordinary < .65
    try
        init = mdl.Coefficients.Estimate;
    catch
        init = starting;
    end
    mdl = fitnlm(x.', y.', func_def, init);
    counter = counter+1;
end

end
