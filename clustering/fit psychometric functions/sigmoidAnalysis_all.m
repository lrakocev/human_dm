function sigmoidAnalysis_all(approach_data, dirName)
       
function [] = createSigmoidFigures(results, dirName,thresh)
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
            
            [fitobject1, gof1]= fit(x.',y.','a*x+b');
            [fitobject2, gof2] = fit(x.', y.', '1 / (1 + (b*exp(-c * x)))');
            [fitobject3, gof3] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');
            [fitobject4, gof4] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');
            [fitobject5, gof5] = fit(x.',y.','a*(x-b)^(2)+c');
            
            if gof3.rsquare >= thresh
               save(strcat(dirName,'Sigmoid Data\',string(subid),"_",string(story_num),'.mat'),'fitobject3') 
            elseif gof4.rsquare >= thresh
                save(strcat(dirName,'Sigmoid Data\',string(subid),"_",string(story_num),'.mat'),'fitobject4') 
            elseif gof2.rsquare >= thresh
                save(strcat(dirName,'Sigmoid Data\',string(subid),"_",string(story_num),'.mat'),'fitobject2')
            elseif gof1.rsquare > gof5.rsquare
               save(strcat(dirName,'Line Data\',string(subid),"_",string(story_num),'.mat'),'fitobject1')
            elseif gof5.rsquare > gof1.rsquare
                save(strcat(dirName,'Parabola Data\',string(subid),"_",string(story_num),'.mat'),'fitobject5')
            end
    
            if gof3.rsquare < 0
                display(strcat("Iteration: ", string(N), " Could not be sorted"))
            end
        end

        close all
    end
end

thresh = 0.4;
N = length(approach_data);
for i = 1:N
    results = approach_data(i);
    createSigmoidFigures(results{1}, dirName,thresh)
end
  
end