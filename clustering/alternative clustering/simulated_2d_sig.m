%% simulation of the 2d sig fit

size_of_grid = 4; 
M = 1000;
want_order = 1;
order_dir = "desc";
sim_table_desc_ordered = [];
for i = 1:M
    random_appr_data = create_random_grid(size_of_grid,want_order,order_dir);
    
    reward_lvls = 1/size_of_grid:1/size_of_grid:1;
    cost_lvls = 1/size_of_grid:1/size_of_grid:1;

    f = fit_2d_sig_helper(reward_lvls, cost_lvls, random_appr_data);

    row.a_R = f.a_R;
    row.b_R = f.b_R;
    row.a_C = f.a_C;
    row.b_C = f.b_C;
          
    sim_table_desc_ordered = [sim_table_desc_ordered; row];
    clear row
    
end

sim_table_desc_ordered = struct2table(sim_table_desc_ordered);

%%

%load("2d_sig_real.mat")

figure
scatter3(sim_table_ordered.a_R, sim_table_ordered.b_R, sim_table_ordered.b_C,'b','o')
hold on
scatter3(sim_table_desc_ordered.a_R, sim_table_desc_ordered.b_R, sim_table_desc_ordered.b_C,'b','o')
hold on
scatter3(sim_table.a_R, sim_table.b_R, sim_table.b_C,'b','o')
hold on
scatter3(sig_table.a_R, sig_table.b_R, sig_table.b_C,'r','x')
xlabel("a_R")
ylabel("b_R")
zlabel("b_C")
title("2d sigmoid simulated vs real data - including ordered in desc+asc + random")