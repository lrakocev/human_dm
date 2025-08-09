function [a,b,c] = get_sigmoid(x,y)

a = nan;
b = nan;
c = nan;

[fitobject1, gof1]= fit(x.',y.','a*x+b');

[fitobject2, gof2] = fit(x.', y.', '1 / (1 + (b*exp(-c * x)))');

[fitobject3, gof3] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');

[fitobject4, gof4] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');

[fitobject5, gof5] = fit(x.',y.','a*(x-b)^(2)+c');

if gof3.rsquare >= .6
    fitobject = fitobject3;
elseif gof4.rsquare >= .6
    fitobject = fitobject4;
elseif gof2.rsquare >= .6
    fitobject = fitobject2;
    a = 1;
elseif gof1.rsquare > gof5.rsquare
    fitobject = fitobject1;
    c = 0;
elseif gof5.rsquare > gof1.rsquare
    fitobject = fitobject5;
else
  return  
end

if isnan(a)
    a = fitobject.a;
end

b = fitobject.b;
if isnan(c)
    c = fitobject.c;
end

end