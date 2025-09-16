%% simulation of the 2d sig fit

size_of_grid = 4; 
M = 5000;

sim_table = [];
for i = 1:M
    random_appr_data = create_random_grid(size_of_grid);
    
    reward_lvls = 1/size_of_grid:1/size_of_grid:1;
    cost_lvls = 1/size_of_grid:1/size_of_grid:1;

    f = fit_2d_sig_helper(reward_lvls, cost_lvls, random_appr_data);

    row.a_R = f.a_R;
    row.b_R = f.b_R;
    row.a_C = f.a_C;
    row.b_C = f.b_C;
          
    sim_table = [sim_table; row];
    
end

sim_table = struct2table(sim_table);

scatter3(sim_table.a_R, sim_table.a_C, sim_table.b_R)