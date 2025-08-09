function aic = calc_aicbic(y, model, num_params)

y_predicted = model(y);
residuals = y - y_predicted;
logL = sum(log(normpdf(y, y_predicted)));





aic = aicbic(logL, num_params);

end