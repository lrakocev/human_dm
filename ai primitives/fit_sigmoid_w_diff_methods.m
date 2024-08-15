function [a,b,c] = fit_sigmoid_w_diff_methods(x,y,sig_type)

if sig_type == 2
    ft = fittype('1 /(1 + (b*exp(-c * x)))');
    a = 1;
elseif sig_type == 3
    ft = fittype('(a/(1+b*exp(-c*(x))))');
else 
    ft = fittype('(a/(1+(b*(exp(-c*(x-d))))))');
end

[fitobject3, ~] = fit(x.',y.',ft);

if sig_type ~=2
    a = fitobject3.a;
end
b = fitobject3.b;
c = fitobject3.c;

end