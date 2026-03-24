function fit_count = sigmoid_analysis_updated(approach_data, dirName, sig_type, thresh)

function was_fit = createSigmoidFigures(results,dirName,thresh,sig_type)
    was_fit = 0;
    if ~isempty(results)
        x=1:4;
        y = [];
        for r = 1:length(x)
            curr = results(results.rew == r, :);
            appr_rate = mean(curr.approach_rate, 'omitnan');
            y = [y; appr_rate];
        end

        y = y';

        if length(y) >= 4 && all(~isnan(y))
            was_fit = 1;
            subid = results.subjectidnumber(1);
            story_num = results.story_num(1);
       
            counter = 1;
            [fitobject2, gof2] = fit(x.', y.', '1 / (1 + (b*exp(-c * x)))');
            while counter <20 && gof2.rsquare < thresh
                [fitobject2, gof2] = fit(x.', y.', '1 / (1 + (b*exp(-c * x)))');
                counter = counter+1;
            end

            counter = 1;
            [fitobject3, gof3] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');
            while counter <20 && gof3.rsquare < thresh
                [fitobject3, gof3] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');
                counter = counter+1;
            end

            counter = 1;
            [fitobject4, gof4] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');
            while counter <20 && gof4.rsquare < thresh
                [fitobject4, gof4] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');
                counter = counter+1;
            end

            if thresh == 0
                max_r = max([gof3.rsquare, gof4.rsquare, gof2.rsquare]);
                if max_r == gof3.rsquare
                    save(strcat(dirName,'Sigmoid Data\',string(subid),"_",string(story_num),'.mat'),'fitobject3') 
                elseif max_r == gof2.rsquare
                    save(strcat(dirName,'Sigmoid Data\',string(subid),"_",string(story_num),'.mat'),'fitobject2') 
                else
                    save(strcat(dirName,'Sigmoid Data\',string(subid),"_",string(story_num),'.mat'),'fitobject4') 
                end
            end

            if thresh ~= 0

                [fitobject1, gof1]= fit(x.',y.','a*x+b');
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
            end

        end
    end
    close all

end

fit_count = 0;
N = length(approach_data);
for i = 1:N
    results = approach_data(i);
    was_fit = createSigmoidFigures(results{1}, dirName,thresh,sig_type);
    fit_count = fit_count + was_fit;
end
end