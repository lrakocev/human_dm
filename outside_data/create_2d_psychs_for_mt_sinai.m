function f = create_2d_psychs_for_mt_sinai(imt_data, id)

subj_table = imt_data(imt_data.id == id, :);

rs = subj_table.rew;
cs = subj_table.cost;
approach_rates = subj_table.approach_rate;

syms R C %just variables to be solved for later on, x and y values 
            
g = fittype( @(a_R,b_R,a_C,b_C,R,C) 1./(1+exp(-a_R.*R+b_R))*1./(1+exp(a_C.*C+b_C)), ...
'coefficients', {'a_R','b_R','a_C','b_C'}, 'independent', {'R', 'C'}, ...
'dependent', 'z' );

counter = 0;
[f, gof] = fit([rs, cs], approach_rates, g, 'StartPoint', [1; 0; 1; 0]); 
while counter < 20 && gof.rsquare < .7
    [f, gof] = fit([rs, cs], approach_rates, g, 'StartPoint', [1; 0; 1; 0]); 
    counter = counter + 1;
end

end
