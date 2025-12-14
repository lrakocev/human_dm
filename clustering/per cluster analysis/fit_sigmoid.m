function [func,r] = fit_sigmoid(x,y,c)

[fitobject1, gof1]= fit(x.',y.','a*x+b');

[fitobject2, gof2] = fit(x.', y.', '1 / (1 + (b*exp(-c * x)))');

[fitobject3, gof3] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');

[fitobject4, gof4] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');

[fitobject5, gof5] = fit(x.',y.','a*(x-b)^(2)+c');

thresh = 0.7; 

if gof3.rsquare >= thresh
    plot(fitobject3,c,x.',y.')
    r = gof3.rsquare;
    func = fitobject3;
elseif gof4.rsquare >= thresh
    plot(fitobject4,c,x.',y.')
    r = gof4.rsquare;
    func = fitobject4;
elseif gof2.rsquare >= thresh
    plot(fitobject2,c,x.',y.')
    r = gof2.rsquare;
    func = fitobject4;
elseif gof1.rsquare > gof5.rsquare
    plot(fitobject1,c,x.',y.')
    r = gof1.rsquare;
    func = fitobject1;
elseif gof5.rsquare > gof1.rsquare
    plot(fitobject5,c,x.',y.')
    r = gof5.rsquare;
    func = fitobject5;
end

end