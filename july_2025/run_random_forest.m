function R2 = run_random_forest(var_table, tit)

dependent_var = var_table.(tit);
var_table.(tit) = [];

t = templateTree('NumVariablesToSample','all',...
    'PredictorSelection','interaction-curvature', 'Surrogate','on');

Mdl = fitrensemble(var_table, dependent_var, 'Method','Bag', 'NumLearningCycles',...
    200, 'Learners', t);

yHat = oobPredict(Mdl);
R2 = corr(Mdl.Y, yHat)^2;

impOOB = oobPermutedPredictorImportance(Mdl);

figure
bar(impOOB)
title('Unbiased Predictor Importance Estimates for ' + tit)
xlabel('Predictor variable')
ylabel('Importance')
h = gca;
h.XTick = 1:length(Mdl.PredictorNames);
h.XTickLabel = Mdl.PredictorNames;
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';

[impGain,predAssociation] = predictorImportance(Mdl);

figure
plot(1:numel(Mdl.PredictorNames),[impOOB' impGain'])
title('Predictor Importance Estimation Comparison for ' + tit)
xlabel('Predictor variable')
ylabel('Importance')
h = gca;
h.XTick = 1:length(Mdl.PredictorNames);
h.XTickLabel = Mdl.PredictorNames;
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';
legend('OOB permuted','MSE improvement')
grid on


end