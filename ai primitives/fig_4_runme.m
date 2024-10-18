%% fig 4 runme

%% create sigmoidal space

% run create_sigmoidal_space.m or load(full space w types.mat)

%% filter space down

% increasing/decreasing, step functions, integer values

final_filter = filter_space(further_filter);

%% plot sigmoidal space

plot_space(final_filter,5000)

%% sampling plot

figure
plot_n = 5000;
to_plot = final_filter;

hs = [];
prev_m = 0;
for i = 1:plot_n
    rand_idx = randperm(height(to_plot), 1);
    row = to_plot(rand_idx,:);

    scatter3(log(abs(row.a)), log(abs(row.b)), log(abs(row.c)));
    hold on    
end
title("final filtered space w/ all types")

%% plot biased version of space

n = 2500;
new_name = "v-" + string(datetime("today"));
further_filter = sortrows(further_filter,{'a','b','c'});
testing_bias_sig_fit(further_filter, n, 'new_name');

%% ai fitting to space

% ai_runme.m

%% compare human clusters to overall space

load('testing_bias_filtered.mat')
type = "all_cost_5_clusters";
table_name = "C:\Users\lrako\OneDrive\Documents\human dm\" + type + ".xlsx";
human_table = readtable(table_name);
shrink_factor = 1;

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\";
percent_space = intersect_model_human_space(model_data, human_table,shrink_factor,save_to);

%% pick point from above that doesn't overlap

%{
v1
a = 2.30685;
b = 4.95814;
c = 5.15586;

tit="far left";
a = -48.7279;
b = -0.911;
c = -0.05;

tit = "far bottom";
a = 2.66425;
b = -1.25456;
c = -29.8884;
%}

tit= "far right";
a = 4;
b = 32.96;
c = 2.7;

plot_both=1;
plot_sigmoid_from_coeffs(a,b,c,plot_both,tit)
