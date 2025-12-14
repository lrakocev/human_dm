function [func,r] = fit_eng_model(x,y,c,story_pref, pupil_diam, hunger, tiredness, pain)

f1 = @(b,x) 100./(1+exp(-(b(1) + b(4) .* hunger) .* (b(2).*x - b(3)*c)));
mdl1 = fitnlm(x.', y.', f1, [1 1 1 1]);

f2 = @(b,x) 100./(1+exp(-(b(1) + b(4) .* story_pref) .* (b(2).*x - b(3)*c)));
mdl2 = fitnlm(x.', y.', f2, [1 1 1 1]);
                                
f3 = @(b,x) 100./(1+exp(-(b(1) + b(4) * pupil_diam) .* (b(2).*x - b(3)*c)));
mdl3 = fitnlm(x.', y.', f3, [1,1,1,1]);

f4 = @(b,x) 100./(1+exp(-(b(1) + b(4) * tiredness) .* (b(2).*x - b(3)*c)));
mdl4 = fitnlm(x.', y.', f4, [1,1,1,1]);

f5 = @(b,x) 100./(1+exp(-(b(1) + b(4) * pain) .* (b(2).*x - b(3)*c)));
mdl5 = fitnlm(x.', y.', f5, [1,1,1,1]);

if mdl1.Rsquared.Ordinary > .6
    func = mdl1;
elseif mdl2.Rsquared.Ordinary > .6
    func = mdl2;
elseif mdl3.Rsquared.Ordinary > .6
    func = mdl3;
elseif  mdl4.Rsquared.Ordinary > .6
    func = mdl4;
elseif  mdl5.Rsquared.Ordinary > .6
   func = mdl5;
else
    func =[];
end

if ~isempty(func)
    x_fit =  linspace(1,4,100);
    prediction = predict(func, x_fit');
    plot(x_fit,prediction)
    r = func.Rsquared.Ordinary;
else
    func =0;
    r = 0;
end
end