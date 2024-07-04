function fit_sigmoid_ai(x,y,save_to,row_num,start)

if ~isempty(start)
    fo = fitoptions('Method','NonlinearLeastSquares','StartPoint', start);
else
    fo = fitoptions('Method','NonlinearLeastSquares');
end
ft = fittype('(a/(1+b*exp(-c*(x))))','options',fo);

[fitobject3, gof3] = fit(x.',y.',ft);
save(save_to + string(row_num) + ".mat",'fitobject3') 

end