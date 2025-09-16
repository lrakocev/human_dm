%% simulation of the 2d sig fit

size_of_arr = 4; 
M = 100;

sig_table = [];
for i = 1:M
 
    random_appr_data = rand(1,size_of_arr);

    reward_lvls = 1/size_of_arr:1/size_of_arr:1;

    f = fit_1d_sig_helper(reward_lvls,random_appr_data);

    if ~isempty(f)
        try
            row.a = f.a;
        catch
            row.a = 1;
        end
        row.b = f.b;
        row.c = f.c;
              
        sig_table = [sig_table; row];
    end
    
end

sig_table = struct2table(sig_table);
log_table = log(abs(sig_table));

scatter3(log_table.a, log_table.a, log_table.b)