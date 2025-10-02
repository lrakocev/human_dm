function [Mdl] = create_decision_tree(state_table, input_features, state_num, want_anova)

state_var = "state_" + state_num;
feature_seqs = state_table(:, input_features);
output_state = state_table.(state_var);

Mdl = fitctree(feature_seqs, output_state);

view(Mdl)
view(Mdl,'mode','graph')

imp = predictorImportance(Mdl);

cvMdl = crossval(Mdl, 'KFold', 10);
kfoldloss = kfoldLoss(cvMdl); % Calculates the k-fold classification loss

% run anova between for each feature between the states

if want_anova
    for i = 1:length(input_features)
        if imp(i) > 0
            feature = input_features(i);
            p = anovan(state_table.(feature), output_state);
            feature
            p 
        end
    end
end

end