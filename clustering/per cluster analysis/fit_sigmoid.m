function fit_sigmoid(x,y)


[fitobject1, gof1]= fit(x.',y.','a*x+b');

[fitobject2, gof2] = fit(x.', y.', '1 / (1 + (b*exp(-c * x)))');

[fitobject3, gof3] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');

[fitobject4, gof4] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');

[fitobject5, gof5] = fit(x.',y.','a*(x-b)^(2)+c');

if gof3.rsquare >= .6
    plot(fitobject3,x.',y.')
elseif gof4.rsquare >= .6
    plot(fitobject4,x.',y.')
elseif gof2.rsquare >= .6
    plot(fitobject2,x.',y.')
elseif gof1.rsquare > gof5.rsquare
    plot(fitobject1,x.',y.')
elseif gof5.rsquare > gof1.rsquare
    plot(fitobject5,x.',y.')
end

end