function f = fit_2d_sig_helper(reward_levels, cost_levels, ps)

syms R C %just variables to be solved for later on, x and y values 
            
g = fittype( @(a_R,b_R,a_C,b_C,R,C) 1./(1+exp(-a_R.*R+b_R))*1./(1+exp(a_C.*C+b_C)), ...
'coefficients', {'a_R','b_R','a_C','b_C'}, 'independent', {'R', 'C'}, ...
'dependent', 'z' );

% Call fit and specify the value of c.

rs = repelem(reward_levels,1,length(reward_levels))';
cs = repmat(cost_levels,1,length(cost_levels))';

f = fit([rs, cs], ps, g, 'StartPoint', [1; 0; 1; 0]); 

end