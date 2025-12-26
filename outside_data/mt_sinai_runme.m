curr_sheet = "avg_data"; % "win_money"
imt_table = readtable("C:\Users\lrako\OneDrive\Documents\human_dm_data\all_k_subject_imt_data.xlsx","Sheet",curr_sheet,"NumHeaderLines",0);

rew = imt_table.Rew;
cost = imt_table.Cost;

curr_table = table;
imt_formatted = [];
var_names = imt_table.Properties.VariableNames;
for j = 1:length(var_names)
    var_name = var_names{j};
    if var_name(1) == "K" & length(var_name) == 4
        id = string(var_name(1:4));
        responses = imt_table.(var_name);
        rts = imt_table.(id + "_RT");
            
        ids_for_rows = repelem(id, length(responses),1);
        curr_table.id = ids_for_rows;

        if curr_sheet == "avg_data"
            curr_table.raw_response = responses;
            curr_table.approach_rate = (responses / 4) * 100;
        else
            number_responses = responses == "y";
            curr_table.raw_response = number_responses;
            curr_table.approach_rate = number_responses * 100;    
        end

        curr_table.reaction_time = rts;
        curr_table.rew = rew;
        curr_table.cost = cost;

        imt_formatted = [imt_formatted; curr_table];
    end
end

%% fitting sigmoids to the imt data

want_plot = 0;
unique_ids = unique(imt_formatted.id);
mt_sinai_trial_table = [];
for j = 1:length(unique_ids)
    id = unique_ids(j);
    [func,type] = create_psychs_for_mt_sinai(imt_formatted, id, want_plot);
    row.id = id; 
    row.type = type;
    if type == "sigmoid"
        row.x_coord = log(abs(func.a));
        row.y_coord = log(abs(func.b));
        row.z_coord = log(abs(func.c));
    else
        row.x_coord = func.a;
        row.y_coord = func.b;
        row.z_coord = func.c;
    end


    mt_sinai_trial_table = [mt_sinai_trial_table; row];
end

mt_sinai_trial_table = struct2table(mt_sinai_trial_table);

%%

num_clusters = 4;
k01_home_folder = "C:/Users/lrako/OneDrive/Documents/human_dm_data";
mt_sinai_cluster_table = sinai_ghrelin_per_cluster("mt_sinai_clusters_2.xlsx",[], num_clusters, k01_home_folder);

%writetable(mt_sinai_cluster_table,"mt_sinai_clusters_2.xlsx","WriteMode","append")

%%

%400s = MDD
disorder_sinai = mt_sinai_trial_table(contains(mt_sinai_trial_table.id, "K4"),:);
healthy_sinai = mt_sinai_trial_table(contains(mt_sinai_trial_table.id, "K5"),:);

cluster_table = readtable("all_clusters_subject.xlsx");

figure
scatter3(cluster_table.clusterX, cluster_table.clusterY, cluster_table.clusterZ,1,'b','o')

hold on 
scatter3(healthy_sinai.x_coord, healthy_sinai.y_coord, healthy_sinai.z_coord,'g','x')

hold on 
scatter3(disorder_sinai.x_coord, disorder_sinai.y_coord, disorder_sinai.z_coord,'r','x')

legend(["our task"; "healthy mt sinai"; "mdd mt sinai"])

title("mt sinai: " + curr_sheet + " vs our task - including poorly fit sigmoids")