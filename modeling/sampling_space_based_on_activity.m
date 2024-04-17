clear; close all
rng('default')
addpath(fileparts(pwd))

% plot the ranges of circuit configurations that are best for achieving
% different spaces 

n_interp_inc = 10;
spaces = dec2bin(0:16-1)' - '0';

max_activity = 5;
[strio_incs,lh_incs,da_incs] = deal(linspace(0,max_activity,n_interp_inc));
[baseline_strio, baseline_LH, baseline_DA] = deal(max_activity/2);

% find the the advantages by space

for j=1:16
    individual_space_advantage_coefs = zeros(16,1);
    % for this loop, only this space is valued
    individual_space_advantage_coefs(j) = 1; 
    advantages{j} = ...
        get_advantage_and_cost_grids(strio_incs,lh_incs,da_incs,...
        individual_space_advantage_coefs,baseline_strio,baseline_LH,baseline_DA);
end
plotter(advantages,strio_incs,lh_incs,da_incs)