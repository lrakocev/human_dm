function [all_trial_table] = cluster_hmm_state_psychs(best_hmms, all_data, fit_type)

coords = [];

all_trial_table = [];
for j = 1:length(best_hmms)
    hmm_row = best_hmms{j};

    if ~isempty(hmm_row)
        state_to_use = hmm_row.plausible_states{1};
        if length(state_to_use) > 1
            state_to_use =  state_to_use(1);
        end

        [state_table,~] = compare_to_og_seq(hmm_row, all_data);

        state_var = "state_" + state_to_use;

        if fit_type == "2d_sigmoid"
            [state_funcs,types] = create_2d_state_psychs(state_table,state_var);
        else
            [state_funcs, types] = create_1d_state_psychs(state_table,state_var,fit_type,1);
        end

        for s = 1:length(state_funcs)
            state_func = state_funcs{s};
            type = types{s};

            if ~isempty(state_func)
                if type == "sigmoid"
                    param_a = log(abs(state_func.a));
                    param_b = log(abs(state_func.b));
                    param_c = log(abs(state_func.c));
                %{
                elseif type == "poly"
                    param_a = state_func(1);
                    param_b = state_func(4);
                    param_c = state_func(2);
                %}
                elseif type == "2d_sigmoid"
                    param_a = state_func.a_R;
                    param_b = state_func.a_C;
                    param_c = state_func.b_R;
                else
                    param_a = state_func.a;
                    param_b = state_func.b;
                    param_c = state_func.c;
                end
    
                curr_state_table = state_table(state_table.(state_var) == s, :);
                num_rows = height(curr_state_table);
                
                curr_state_table.x_coord = repelem(param_a,num_rows,1);
                curr_state_table.y_coord = repelem(param_b,num_rows,1); 
                curr_state_table.z_coord = repelem(param_c,num_rows,1);
                curr_state_table.psych_type = repelem(type,num_rows,1);
    
                all_trial_table = [all_trial_table; curr_state_table];
            end
        end
    end
end
close all
end