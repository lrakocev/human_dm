function norm_arr = activity_given_dim(advantages, dim)

% P(config | dim) = P(dim | config) * P(config) / P(dim) 

adv_of_interest = advantages{dim+1};
total_for_dim = sum(adv_of_interest);

total_across_space = sum(cell2mat(advantages));
p_dim = total_for_dim / total_across_space;

% for a given config of brain activity, there's only one possible dim
p_dim_given_config = 1; 

cond_prob_arr = [];
for i = 1:length(adv_of_interest)
    config_prob = adv_of_interest(i);
    p_config = config_prob / total_for_dim;
    cond_prob = p_dim_given_config * p_config / p_dim;
    cond_prob_arr = [cond_prob_arr; cond_prob];
end

norm_arr = cond_prob_arr / sum(cond_prob_arr);

end