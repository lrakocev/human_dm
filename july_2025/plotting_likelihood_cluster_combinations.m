% get full table of behavioral data 

load("autoencoder_table.mat");
load("hum_data_oct25.mat")
all_data = [];
for j = 1:length(all_trial_data)
    all_data = [all_data; all_trial_data{j}];
end


%% 1d clusters

table_name = "C:\Users\lrako\OneDrive\Documents\human_dm\october_2025\all_clusters_subject.xlsx";
clusters_1d = readtable(table_name);

clusters_1d = psychs_in_spec_cluster(clusters_1d,0);

%% 2d clusters

type = "2d_clustering_subject_lvl_all_data_oct25";
table_name = "C:\Users\lrako\OneDrive\Documents\human_dm\july_2025\" + type + ".xlsx";
clusters_2d = readtable(table_name);

clusters_2d = psychs_in_spec_cluster(clusters_2d, 0);

%% join 1d+2d in one table

cluster_merged = outerjoin(clusters_2d,clusters_1d,'Keys',{'experiment','subjectidnumber'},'MergeKeys',1);
cluster_merged = renamevars(cluster_merged, "experiment", "story_type");

auto_merged = outerjoin(cluster_merged, full_autoencoder_table, 'Keys', {'story_type','subjectidnumber'},'MergeKeys',1);

behavior_merged = outerjoin(auto_merged,all_data,'Keys',{'story_type','subjectidnumber'},'MergeKeys',1);
%behavior_merged = renamevars(behavior_merged, "cost_all_data","cost");

behavior_merged = behavior_merged(~isnan(behavior_merged.approach_rate) & ~isnan(behavior_merged.auto_cluster) ...
    & ~isnan(behavior_merged.idx_clusters_2d) & ~isnan(behavior_merged.idx_clusters_1d),:);

%%

cluster_combos= groupcounts(behavior_merged, ["idx_clusters_1d", "idx_clusters_2d", "auto_cluster"]);


figure
for a = 1:max(cluster_combos.idx_clusters_1d)
    for b = 1:max(cluster_combos.idx_clusters_2d)
        for c = 1:max(cluster_combos.auto_cluster)
            scatter3(a,b,c,10,'b','filled')
            hold on
        end
    end
end

for i = 1:height(cluster_combos)
    cluster_combo = cluster_combos(i,:);

    sigmoid_1d = cluster_combo.idx_clusters_1d;
    sigmoid_2d = cluster_combo.idx_clusters_2d;
    autoenc = cluster_combo.auto_cluster;
    
    prob = cluster_combo.Percent;

    scatter3(sigmoid_1d, sigmoid_2d, autoenc, prob*100, 'r','filled')
    hold on
end

title('probability of cluster combinations across methods')
xlabel('1d sigmoid cluster')
ylabel('2d sigmoid cluster')
zlabel('autoencoder cluster')
set(gcf,'renderer','Painters')
%savefig(save_to + "\prob_of_behavior_" + story_type + ".fig")

biggest_combos = cluster_combos(cluster_combos.Percent > 10, :);

