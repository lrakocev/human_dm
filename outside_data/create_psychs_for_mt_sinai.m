function [func,type] = create_psychs_for_mt_sinai(imt_data, id, want_plot)

subj_table = imt_data(imt_data.id == id, :);
rew_lvls = sort(unique(subj_table.rew));

all_lvl_appr_rates = [];
for k = 1:length(rew_lvls)
    lvl = rew_lvls(k);
    lvl_appr_rates = subj_table(subj_table.rew == lvl, :).approach_rate;

    all_lvl_appr_rates = [all_lvl_appr_rates lvl_appr_rates];
end

y = mean(all_lvl_appr_rates, 1, 'omitnan');
x = 1:length(rew_lvls);

counter = 0;
[sigmoid_func, gof_sig] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');
while counter < 20 && gof_sig.rsquare < .7
    [sigmoid_func, gof_sig] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');
    counter = counter+1;
end 

func = sigmoid_func;
type = "sigmoid";

%{
counter = 0;
[parabolic_func, gof_parab] = fit(x.',y.','a*(x-b)^(2)+c');
while counter < 20 && gof_parab.rsquare < .7
    [parabolic_func, gof_parab] = fit(x.',y.','a*(x-b)^(2)+c');
    counter = counter+1;
end 

if gof_parab.rsquare > gof_sig.rsquare
    func = parabolic_func;
    type = "parabola";
else
    func = sigmoid_func;
    type = "sigmoid";
end
%}
if want_plot
    figure
    plot(func, x.', y.')   
    title('psych for mt sinai subj ' + id)
end

end