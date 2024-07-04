function [a,b,c] = fit_sigmoid_w_diff_methods(x,y,start,alg_num,robust_num)

algs = {"Trust-Region", "Levenberg-Marquardt"};
robust = {"off","LAR","Bisquare"};

fo = fitoptions('Method','NonlinearLeastSquares','StartPoint', start,...
    'Algorithm', algs{alg_num}, 'Robust', robust{robust_num},...
    'TolFun', 1e-5, 'MaxFunEvals',750, 'MaxIter', 600);
    %'Upper',start,'Lower',start);

ft = fittype('(a/(1+b*exp(-c*(x))))','options',fo);

[fitobject3, ~] = fit(x.',y.',ft);
a = fitobject3.a;
b = fitobject3.b;
c = fitobject3.c;

end