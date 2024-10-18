%% get behavioral data

% to get session data, need to run the hum_new_tasks_runme 

load("C:\Users\lrako\OneDrive\Documents\human dm\ingest helpers\human data.mat")

%% find session-cost sigmoids

story_types = ["approach_avoid", "social", "probability", "moral"];
data{1} = appr_avoid_sessions;
data{2} = social_sessions;
data{3} = probability_sessions;
data{4} = moral_sessions;

poly_table = run_alt_fit(data,story_types, 1);
sig_table = run_alt_fit(data,story_types, 0);

poly_table.clusterLabels = poly_table.subjectidnumber + "_" + poly_table.story_num + ".mat";
sig_table.clusterLabels = sig_table.subjectidnumber + "_" + sig_table.story_num + ".mat";


%% viz of poly coeffs

want_poly = 0;
if want_poly
    figure
    scatter3(poly_table.b, poly_table.c, poly_table.d,'o')
    title("polynomial b c d")
    figure
    scatter3(poly_table.a, poly_table.c, poly_table.d,'o')
    title("polynomial a c d")

else
    a_R = sig_table.a_R;
    a_C = sig_table.a_C;
    b_R = sig_table.b_R;
    b_C = sig_table.b_C;
    figure
    scatter3(a_R, b_R, b_C,'o')
    title("a_R, b_R, b_C")
    set(gcf,'renderer','Painters')
    %saveas(gcf, save_to + "\2d sig not clustered","fig")
end    

%% clustering 2d sigs 

num_clusters = 30;
method = 'density';
colors = distinguishable_colors(num_clusters);
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\2d sig clustering";
mkdir(save_to)
file_name = method + "_v1";
feats = ["a_R","b_R","b_C"];
spectral_clustering_2D_sig(sig_table, feats, num_clusters, method, colors, save_to, file_name)

%% merge table to other clustering method 

type = "all_session_updated";
main_hum = readtable("C:\Users\lrako\OneDrive\Documents\human dm\" + type + ".xlsx");

all_merged = outerjoin(sig_table, main_hum, "Keys", {'experiment','clusterLabels'},"MergeKeys", 1);
clean_merged = all_merged(~isnan(all_merged.cluster_number),:);

%% plot 2d sig params using prev cluster numbers

num_clusters = length(unique(clean_merged.cluster_number));
colors = distinguishable_colors(num_clusters);
for i = 1:num_clusters
    curr_color = colors(i,:);
    curr_table = clean_merged(clean_merged.cluster_number == i, :);
    a_R = curr_table.a_R;
    a_C = curr_table.a_C;
    b_R = curr_table.b_R;
    b_C = curr_table.b_C;
    
    scatter3(a_R, b_R, b_C,[],curr_color);
    hold on
   
end
        
title("a_R, a_C, b_C")
hold off 


%% what was included vs not included originally?

all_merged.in_cluster = ~isnan(all_merged.cluster_number);
in_cluster = all_merged(all_merged.in_cluster, :);

out_cluster = all_merged(~all_merged.in_cluster, :);

figure
scatter3(in_cluster.a_R, in_cluster.a_C, in_cluster.b_C,'o','r');
hold on
scatter3(out_cluster.a_R, out_cluster.a_C, out_cluster.b_C,'o','b');

legend(["in";"out"])
title("num in: " + string(height(in_cluster)) + ", num out: " + string(height(out_cluster)))

% todo - check the numbers here, do they make sense?

%% dec making plot per "cluster"

want_plot = 1;
same_scale = 1;
use_cost = 0;
using_1d_sig = 0;
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\figs\" + type + "\2d sig clustering";

story_types = ["all","approach_avoid", "social", "probability", "moral"];
all_data{1} = [appr_avoid_sessions moral_sessions social_sessions probability_sessions];
all_data{2} = appr_avoid_sessions;
all_data{3} = social_sessions;
all_data{4} = probability_sessions;
all_data{5} = moral_sessions;
split_by_dim = 0;
plot_interactions = 0;

table_name = "density_v1.xlsx";
input_table = readtable("C:\Users\lrako\OneDrive\Documents\human dm\figs\all_session_updated\2d sig clustering\" + table_name);
all_psych_data = plot_avg_spec_cluster_psychs(input_table, all_data, same_scale, story_types, save_to, want_plot, split_by_dim, use_cost,plot_interactions);


