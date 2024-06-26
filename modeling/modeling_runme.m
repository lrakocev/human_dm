%% clusters runme using spectral clustering table

table_name = "C:\Users\lrako\OneDrive\Documents\human dm\all_human_data.xlsx";
spectral_table = readtable(table_name);

%% get behavioral data

% to get session data, need to run the hum_new_tasks_runme 

%% concatenating the session tables into one big table per task

want_plot = 1;
same_scale = 1;
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\test_run\avg_cluster_info";
story_types = ["approach_avoid", "social", "probability", "moral", "all"];
all_data{1} = appr_avoid_sessions;
all_data{2} = social_sessions;
all_data{3} = probability_sessions;
all_data{4} = moral_sessions;
all_data{5} = [appr_avoid_sessions moral_sessions social_sessions probability_sessions];

all_psych_data = plot_avg_spec_cluster_psychs(spectral_table, all_data, same_scale, story_types, save_to, want_plot);
all_psych_data = renamevars(all_psych_data,'experiment','story_type');

%% activity -> dims 
n_interp_inc = 10;
spaces = dec2bin(0:16-1)' - '0';

max_activity = 3;
[strio_incs,lh_incs,da_incs] = deal(linspace(0,max_activity,n_interp_inc));
[baseline_strio, baseline_LH, baseline_DA] = deal(max_activity/2);

n = 2^2;
for j=1:n
    individual_space_advantage_coefs = zeros(n,1);
    % for this loop, only this space is valued
    individual_space_advantage_coefs(j) = 1; 
    advantages{j} = ...
        get_advantage_and_cost_grids(strio_incs,lh_incs,da_incs,...
        individual_space_advantage_coefs,baseline_strio,baseline_LH,baseline_DA);
end

 [example_advantage, strio_indxs, lh_indxs, da_indxs] = plotter(advantages,strio_incs,lh_incs,da_incs);


%% map dimensions (manually)

approach_avoid_dims = {0,1,2,0,0,2,2,2,1};
moral_dims={0,1,1,0,0,1,2,1,1};
prob_dims = {0,1,2,0,2,1,0,2,1};
social_dims = {0,1,1,0,1,2,2,0,1};

%%
 
dim = 2; %btwn 0-2
cond_probs = activity_given_dim(example_advantage, dim);
plot_activity_from_dim(cond_probs, dim, strio_indxs, lh_indxs, da_indxs)
savefig('prob_of_config_given_dim_' + string(dim) + '.fig')


