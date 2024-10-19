%% artifact discussion

%% create sigmoidal space

% run create_sigmoidal_space.m or load(full space w types.mat)

%% get space produced by matlab sigmoid fitting 

% load("C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\figs\orig_sampled\testing_model_bias_0917.mat") or run:
new_name = "v-" + string(datetime("today"));
n = 2500;
further_filter = sortrows(further_filter,{'a','b','c'});
model_data = testing_bias_sig_fit(further_filter, n, new_name);

%% find clusters in the space

% load(new_name) % from above
num_clusters = 50;
colors = distinguishable_colors(num_clusters);
new_name = "v-" + string(datetime("today"));
cluster_sig_space(model_data,"new_name",num_clusters,colors,'euclidean',"local_minima_clustered");

%% compare local minima clustering to human

type ="orig_sampled";
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\figs\" + type + "\";
theo_table_name = save_to + "local_minima_clustered.xlsx";
theo_data = readtable(theo_table_name);

type = "all_cost_5_clusters";
table_name = "C:\Users\lrako\OneDrive\Documents\human dm\" + type + ".xlsx";
human_data = readtable(table_name);

version_name = "hum_v_theory_2";

colors = distinguishable_colors(60);
bhatt_table = get_bhat_dist_heat_map_comparing_rat_to_human(human_data,theo_data,0, save_to,version_name,1,0);
non_mapping_idx = compare_densities(human_data, theo_data, bhatt_table);

%% compare human clusters to overall space

%load("C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\figs\orig_sampled\testing_model_bias_0917.mat") %or run:
type = "all_session_updated";
table_name = "C:\Users\lrako\OneDrive\Documents\human dm\" + type + ".xlsx";
human_table = readtable(table_name);
shrink_factor = 1;

save_to = "C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\";
percent_space = intersect_model_human_space(model_data, human_table,shrink_factor,save_to);

%% avg psychs from far-off clusters

type ="orig_sampled";
save_to = "C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\figs\" + type + "\";
theo_table_name = save_to + "local_minima_clustered.xlsx";
theo_data = readtable(theo_table_name);

want_2_param = 0;
want_3_param = 1;
d = -5;
want_avg = 0;
clusters_of_interest = [5, 13, 28, 30, 32, 40];
for i = 1:length(clusters_of_interest)
    cl = clusters_of_interest(i);
    cluster_table = theo_data(theo_data.cluster_number == cl, :);
    
    if want_avg
        a = mean(cluster_table.rawX,'omitnan');
        b = mean(cluster_table.rawY,'omitnan');
        c = mean(cluster_table.rawZ,'omitnan');
    
        nexttile 
        fplot(@(x) a/(1+b*exp(-c*(x))))

    end
    
    figure
    num_sig = 60;
    choose = min(num_sig, height(cluster_table));
    rand_idx = randperm(height(cluster_table), choose);
    for j = 1:choose %height(cluster_table)
        curr_j = rand_idx(j);
        row = cluster_table(curr_j,:);
        a = row.rawX;
        b = row.rawY;
        c = row.rawZ;

        lvl_4 = a/(1+b*exp(-c*4));

        if lvl_4  >= 5
        nexttile
        if want_2_param
            fplot(@(x) 1/(1+b*exp(-c*(x))))
        elseif want_3_param
            fplot(@(x) a/(1+b*exp(-c*(x))))
        else
            fplot(@(x) a/(1+b*exp(-c*(x-d))))
        end
        %ylim([0 100])
        end
    end
    sgtitle("cluster " + string(cl))
    set(gcf,'renderer','Painters')
    saveas(gcf,"cluster " + string(cl) + " sig examples.fig", 'fig')
    saveas(gcf,"cluster " + string(cl) + " sig examples.svg", 'svg')
end


