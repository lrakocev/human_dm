function [distances,cluster_diffs] = get_distances_btwn_funcs(table_of_data, num_functions_to_try,num_comparisons,using_fitted_vals,using_2d_sigmoid,sigmoid_table_2d,raw_sesh_data_across_rew)

if using_fitted_vals
    if ~using_2d_sigmoid
        %{
        table_of_data = cell2table(cell(0,5),"VariableNames",["A","B","C","D","E"]);
        directory_where_cluster_table_should_be_saved = create_a_file_if_it_doesnt_exist_and_ret_abs_path(directory_where_cluster_table_should_be_saved);
        
        for i=1:height(table_of_dir)
            current_table = getTableBig(table_of_dir{i,2},0);
            E = repelem(table_of_dir{i,1},height(current_table),1);
            E = table(E);
            current_table = [current_table,E];
            table_of_data = [table_of_data;current_table];
        end

        raw_xVsYVsZ = [table_of_data.A,table_of_data.B,table_of_data.C];
        %}

        raw_xVsYVsZ = [table_of_data.rawX,table_of_data.rawY, table_of_data.rawZ];
        cluster_idx = table_of_data.cluster_number;
      
        if ~isempty(num_functions_to_try)
            total_sessions_to_try = randperm(size(raw_xVsYVsZ,1), num_functions_to_try);
            raw_xVsYVsZ = raw_xVsYVsZ(total_sessions_to_try, :);
            cluster_idx = cluster_idx(total_sessions_to_try);
        end
    
        all_outputs = [];
        for j = 1:size(raw_xVsYVsZ, 1)
            params = raw_xVsYVsZ(j, :);
            output_vals = test_sig([1,2,3,4],params(1), params(2), params(3));
            all_outputs = [all_outputs; output_vals];
        end
    else
        cost_levels = 1/4:1/4:1;
        reward_levels = 1/4:1/4:1;

        rs = repelem(reward_levels,1,length(reward_levels))';
        cs = repmat(cost_levels,1,length(cost_levels))'; 
        all_outputs = [];
        for j = 1:height(sigmoid_table_2d)
            params = sigmoid_table_2d(j, :);
            output_vals = test_2d_sig(rs, cs, params.a_R, params.b_R, params.a_C, params.b_C);
            all_outputs = [all_outputs; output_vals'];
        end
        
    end
else 
    all_outputs = raw_sesh_data_across_rew;
end

pairs = nchoosek(1:size(all_outputs,1), 2);

if num_comparisons < length(pairs)
    random_idx = randperm(length(pairs), num_comparisons);
    pairs = pairs(random_idx, :);
end

distances = [];
cluster_diffs = [];
for k = 1:size(pairs,1)
    pair = pairs(k,:);
    r1 = all_outputs(pair(1), :);
    r2 = all_outputs(pair(2), :);
    c1 = cluster_idx(pair(1));
    c2 = cluster_idx(pair(2));
    
    cluster_diffs = [cluster_diffs; c1 - c2 c1 c2];
    dists = get_func_distance(r1, r2);
    distances = [distances; dists];
end

end

function y = test_sig(x, a, b, c)
    y = a./(1+b*exp(-c.*(x)));
end

function dist = get_func_distance(set1, set2)
    dist = (set1 - set2).^2;
end

function y = test_2d_sig(R, C, a_R, b_R, a_C, b_C)
    y = 1./(1+exp(-a_R.*R+b_R))* 1./(1+exp(a_C.*C+b_C));
end