function [P_rsq] = predict_appr_entropy(entropy_table,measure,sub_tit)

if isempty(sub_tit)
    sub_tit = "all data";
end

rew = entropy_table.rew;
cost = entropy_table.cost;
measure_data = entropy_table.(measure+"_lvl");
appr_entropy = entropy_table.appr_entropy;
appr_mean = entropy_table.appr_mean;

% rew(:) cost(:) 
xs = [measure_data(:)];
y = [appr_entropy];

%{
func = @(b,x) b(1).*x(:,1).^2 + b(2).*x(:,1) + b(3);

%u-shaped
beta0=[1;1;1];
mdl = fitnlm(xs,y,func,beta0);
rsq = mdl.Rsquared.Ordinary;

pred = predict(mdl,xs);


figure
plot(xs,y,'o',xs,pred,'-')
title("rsq of parabolic fit for " + measure + "vs appr entropy in " + sub_tit + " = " + rsq)
hold off
%}

[p,S] = polyfit(xs,y,7);
P_rsq = 1 - (S.normr/norm(y - mean(y)))^2;

if isempty(sub_tit)
    figure
end
f = polyval(p,xs); 
plot(xs,y,'o',xs,f,'-') 
title("rsq of poly fit for " + measure + " vs appr entropy in " + sub_tit + " = " + P_rsq)
xlabel(measure)
ylabel("appr entropy")
hold off 
end