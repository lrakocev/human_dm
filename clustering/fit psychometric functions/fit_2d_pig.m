function[] = fit_2d_pig(results, dirName, sig_type)

        cost_levels = 1:1:4;
        reward_levels = 1:1:4;
        rs = repelem(reward_levels,1,4)'; %repeat the reward levels array 4 times (1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4)
        cs = repmat(cost_levels,1,4)'; %repeat the cost_levels array 4 times (1 2 3 4 1 2 3 4 1 2 3 4 1 2 3 4)
        appr = zeros(4*4,1); %create a 16x1 array which will be populated later
    
        i = 1;
        for r = 1:4
            for c = 1:4
                appr(i) = mean(results(results.rew == r & results.cost == c, :).approach_rate, 'omitnan');
                i = i+1;
            end
        end

        if ~isempty(results)
            if sig_type == "cost"
                results = sortrows(results, "rew");
            else
                results = sortrows(results, "cost");
        end
            
        story_pref = mean(results.story_prefs(1), 'omitnan');
        pupil_diam = mean(results.pupil_diameter, 'omitnan');
        hunger = mean(results.hunger, 'omitnan');
        tiredness = mean(results.tiredness, 'omitnan');
        pain = mean(results.pain, 'omitnan');
        
                
        subid = results.subjectidnumber(1);
        story_num = results.story_num(1);  
        
        syms R C

        f1 = fittype(@(b1,b2,b3,R,C) 100./(1+exp(-b1.*(b2.*R - b3.*C))), ...
        'coefficients', {'b1','b2','b3'}, 'independent', {'R', 'C'}, ...
        'dependent', 'z');
        [mdl1, gof1]= fit_model(rs, cs, appr, f1);
        
        f2 = fittype(@(b1,b2,b3,b4,R,C) 100./(1+exp(-(b1 + b4 .* story_pref) .* (b2.*R - b3*C))),...
        'coefficients', {'b1','b2','b3','b4'}, 'independent', {'R', 'C'}, ...
        'dependent', 'z');
        [mdl2, gof2] = fit_model(rs, cs, appr, f2);
                    
        f3 =  fittype(@(b1,b2,b3,b4,R,C) 100./(1+exp(-(b1 + b4 .* pupil_diam) .* (b2.*R - b3*C))),...
        'coefficients', {'b1','b2','b3','b4'}, 'independent', {'R', 'C'}, ...
        'dependent', 'z');
        [mdl3, gof3] = fit_model(rs, cs, appr, f3);
        
        f4 =  fittype(@(b1,b2,b3,b4,R,C) 100./(1+exp(-(b1 + b4 .* hunger) .* (b2.*R - b3*C))),...
        'coefficients', {'b1','b2','b3','b4'}, 'independent', {'R', 'C'}, ...
        'dependent', 'z');
        [mdl4, gof4] = fit_model(rs, cs, appr, f4);
        
        f5 =  fittype(@(b1,b2,b3,b4,R,C) 100./(1+exp(-(b1 + b4 .* tiredness) .* (b2.*R - b3*C))),...
        'coefficients', {'b1','b2','b3','b4'}, 'independent', {'R', 'C'}, ...
        'dependent', 'z');
        [mdl5, gof5] = fit_model(rs, cs, appr, f5);
        
        f6 =  fittype(@(b1,b2,b3,b4,R,C) 100./(1+exp(-(b1 + b4 .* pain) .* (b2.*R - b3*C))),...
        'coefficients', {'b1','b2','b3','b4'}, 'independent', {'R', 'C'}, ...
        'dependent', 'z');
        [mdl6, gof6] = fit_model(rs, cs, appr, f6);
        
        save(strcat(dirName,'cannon/',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'mdl1') 
        save(strcat(dirName,'story_pref/',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'mdl2') 
        save(strcat(dirName,'pupil_diam/',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'mdl3') 
        save(strcat(dirName,'hunger/',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'mdl4') 
        save(strcat(dirName,'tiredness/',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'mdl5') 
        save(strcat(dirName,'pain/',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'mdl6') 
        
        save(strcat(dirName,'cannon_r/',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'gof1') 
        save(strcat(dirName,'story_pref_r/',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'gof2') 
        save(strcat(dirName,'pupil_diam_r/',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'gof3') 
        save(strcat(dirName,'hunger_r/',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'gof4') 
        save(strcat(dirName,'tiredness_r/',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'gof5') 
        save(strcat(dirName,'pain_r/',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'gof6') 
        
        close all
        
    end

          


end

function [mdl,gof] = fit_model(rs, cs, appr, func)

counter = 1;
try
    [mdl,gof] = fit([rs, cs], appr, func, 'StartPoint', [1; 0; 1; 0]); 
catch
    mdl = 0;
    gof = 0;
    return
end
while counter < 20 && gof.rsquare < .65
    [mdl,gof] = fit([rs, cs], appr, func); 
    counter = counter+1;
end

end
