function func = fit_1d_sig_helper(x,y)

[fitobject2, gof2] = fit(x.', y.', '1 / (1 + (b*exp(-c * x)))');

[fitobject3, gof3] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');

[fitobject4, gof4] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');

if gof3.rsquare >= .4
    r = gof3.rsquare;
    func = fitobject3;
elseif gof4.rsquare >= .4
    r = gof4.rsquare;
    func = fitobject4;
elseif gof2.rsquare >= .4
    r = gof2.rsquare;
    func = fitobject2;
else
    func = [];
end

end