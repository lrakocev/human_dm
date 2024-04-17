function sigmoidAnalysis_lara(approach_data, dirName)
    function[] = createSigmoidFigures(results,c,appr_rate_or_timing, dirName)
        if ~isempty(results)
            constant_cost = results(results.cost == c,:);
            x = constant_cost.rew.';
        
            if length(x) >= 4
    
                if appr_rate_or_timing == "appr_rate"
                    y = constant_cost.approach_rate.';
                    y(isnan(y)) = mean(y, 'omitnan');
                    ext = "approach rates";
                end
                subid = constant_cost.subjectidnumber(1);
                story_num = constant_cost.story_num(1);
                
                figure
                [fitobject1, gof1]= fit(x.',y.','a*x+b');
                figure1 = plot(fitobject1,x.',y.');
                ylabel("Choice")
                xlabel("Reward")
                fighandle1 = gcf;
                
                figure 
                [fitobject2, gof2] = fit(x.', y.', '1 / (1 + (b*exp(-c * x)))');
                figure2 = plot(fitobject2, x.', y.');
                ylabel("Choice")
                xlabel("Reward")
                title("2 Param Sigmoid")
                fighandle2 = gcf;
                
                figure
                [fitobject3, gof3] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');
                figure3 = plot(fitobject3,x.',y.');
                ylabel("Choice")
                xlabel("Reward")
                title("3 Param. Sigmoid")
                fighandle3 = gcf;
        
        
                figure 
                [fitobject4, gof4] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');
                figure4 = plot(fitobject4, x.', y.');
                ylabel("Choice")
                xlabel("Reward")
                title("4 Param. Sigmoid")
                fighandle4 = gcf;
               
        
                figure
                [fitobject5, gof5] = fit(x.',y.','a*(x-b)^(2)+c');
                figure5 =plot(fitobject5,x.',y.');
                ylabel("Choice")
                xlabel("Reward")
                title("Parabola")
                fighandle5 = gcf;
               
                if gof3.rsquare >= .6
                    saveas(fighandle3,strcat(dirName,"3 Parameter Sigmoid\",string(subid),"_",string(story_num),"_cost_",string(c),".fig"))
                    save(strcat(dirName,'Sigmoid Data\',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'fitobject3') 
                elseif gof4.rsquare >= .6
                    saveas(fighandle4,strcat(dirName,"4 Parameter Sigmoid\",string(subid),"_",string(story_num),"_cost_",string(c),".fig"))
                    save(strcat(dirName,'Sigmoid Data\',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'fitobject4') 
                elseif gof2.rsquare >= .6
                    saveas(fighandle2,strcat(dirName,"2 Parameter Sigmoid\",string(subid),"_",string(story_num),"_cost_",string(c),".fig"))
                    save(strcat(dirName,'Sigmoid Data\',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'fitobject2')
                elseif gof1.rsquare > gof5.rsquare
                    saveas(fighandle1,strcat(dirName,"Lines\",string(subid),"_",string(story_num),"_cost_",string(c),".fig"))
                    save(strcat(dirName,'Line Data\',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'fitobject1')
                elseif gof5.rsquare > gof1.rsquare
                    saveas(fighandle5,strcat(dirName,"Parabolas\",string(subid),"_",string(story_num),"_cost_",string(c),".fig"))
                    save(strcat(dirName,'Parabola Data\',string(subid),"_",string(story_num),"_cost_",string(c),'.mat'),'fitobject5')
                end
        
                if gof3.rsquare < 0
                    display(strcat("Iteration: ", string(N), " Could not be sorted"))
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
        createSigmoidFigures(results, c, "appr_rate", dirName)
    end
end

end