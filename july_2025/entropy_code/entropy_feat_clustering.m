%% clustering using other features

entropy_results = calc_feat_per_session(session_data, @calc_entropy);
variance_results = calc_feat_per_session(session_data, @var);
%enthalpy_results = calc_feat_per_session(session_data, @calc_enthalpy);
mean_results = calc_feat_per_session(session_data, @mean);

scatter3(entropy_results, variance_results, mean_results)
xlabel("entropy")
ylabel("variance")
zlabel("mean")


scatter(entropy_results, variance_results)
xlabel("entropy")
ylabel("variance")
xlim([-1e4, 0])