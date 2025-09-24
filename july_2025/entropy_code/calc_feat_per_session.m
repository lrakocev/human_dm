function func_results = calc_feat_per_session(session_data, func)

func_results = [];
for i = 1:length(session_data)
    task_data = session_data{1,i};
    for j = 1:length(task_data)
        session = task_data(j);
        vals = session{1}.approach_rate;
        func_result = func(vals);
        func_results = [func_results; func_result];
    end
end

end