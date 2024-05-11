function sigmoid_analysis_updated(approach_data, dirName, sig_type)

function [] = createSigmoidFigures(results,dirName,thresh,sig_type)

    if ~isempty(results)
        if sig_type == "cost"
            x = unique(results.rew)';
        else
            x = unique(results.cost)';
        end
          
        
        y = [];
        for r = 1:length(x)
            if sig_type == "cost"
                curr = results(results.rew == r, :);
            else
                curr = results(results.cost == r, :);
            end
            appr_rate = mean(curr.approach_rate, 'omitnan');
            y = [y; appr_rate];
        end

        y = y';


        if length(y) >= 4 && all(~isnan(y))
        
            subid = results.subjectidnumber(1);
            story_num = results.story_num(1);
       
            [fitobject1, gof1]= fit(x.',y.','a*x+b');

            counter = 1;
            [fitobject2, gof2] = fit(x.', y.', '1 / (1 + (b*exp(-c * x)))');
            while counter <20 && gof2.rsquare < .4
                [fitobject2, gof2] = fit(x.', y.', '1 / (1 + (b*exp(-c * x)))');
                counter = counter+1;
            end

            counter = 1;
            [fitobject3, gof3] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');
            while counter <20 && gof3.rsquare < .4
                [fitobject3, gof3] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');
                counter = counter+1;
            end

            counter = 1;
            [fitobject4, gof4] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');
            while counter <20 && gof4.rsquare < .4
                [fitobject4, gof4] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');
                counter = counter+1;
            end

            [fitobject5, gof5] = fit(x.',y.','a*(x-b)^(2)+c');

            if gof3.rsquare >= thresh
                plot(fitobject3,x.',y.');
                xlabel("Reward")
                ylabel("Choice")
                title("3 Param Sigmoid")
                fighandle3 = gcf;
                set(fighandle3, 'visible', 'on');
                saveas(fighandle3,strcat(dirName,"3 Parameter Sigmoid\",string(subid),"_",string(story_num),".fig"))
                 save(strcat(dirName,'Sigmoid Data\',string(subid),"_",string(story_num),'.mat'),'fitobject3') 
            elseif gof4.rsquare >= thresh
                plot(fitobject4, x.', y.');
                ylabel("Choice")
                xlabel("Reward")
                title("4 Param Sigmoid")
                fighandle4 = gcf;
                set(fighandle4, 'visible', 'on');
                saveas(fighandle4,strcat(dirName,"4 Parameter Sigmoid\",string(subid),"_",string(story_num),".fig"))
                save(strcat(dirName,'Sigmoid Data\',string(subid),"_",string(story_num),'.mat'),'fitobject4') 
            elseif gof2.rsquare >= thresh
                plot(fitobject2, x.', y.');
                ylabel("Choice")
                xlabel("Reward")
                title("2 Param Sigmoid")
                fighandle2 = gcf;
                set(fighandle2, 'visible', 'on');
                saveas(fighandle2,strcat(dirName,"2 Parameter Sigmoid\",string(subid),"_",string(story_num),".fig"))
                save(strcat(dirName,'Sigmoid Data\',string(subid),"_",string(story_num),'.mat'),'fitobject2')
            elseif gof1.rsquare > gof5.rsquare
                plot(fitobject1,x.',y.');
                ylabel("Choice")
                xlabel("Reward")
                title("Line")
                fighandle1 = gcf;
                set(fighandle1, 'visible', 'on');
                saveas(fighandle1,strcat(dirName,"Lines\",string(subid),"_",string(story_num),".fig"))
                save(strcat(dirName,'Line Data\',string(subid),"_",string(story_num),'.mat'),'fitobject1')
            elseif gof5.rsquare > gof1.rsquare
                plot(fitobject5,x.',y.');
                xlabel("Reward")
                ylabel("Choice")
                title("Parabola")
                fighandle5 = gcf;
                set(fighandle5, 'visible', 'on');
                saveas(fighandle5,strcat(dirName,"Parabolas\",string(subid),"_",string(story_num),".fig"))
                save(strcat(dirName,'Parabola Data\',string(subid),"_",string(story_num),'.mat'),'fitobject5')
            
            end

        end
    end
    close all

end

thresh = 0.4;
N = length(approach_data);
for i = 1:N
    results = approach_data(i);
    createSigmoidFigures(results{1}, dirName,thresh,sig_type)
end
end