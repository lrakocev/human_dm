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

%% can just load the existing fit sigmoid data - this is fit to avg_data

load("C:\Users\lrako\OneDrive\Documents\human_dm\outside_data\mt_sinai_trial_table.mat")

%% fitting sigmoids to the imt data

want_plot = 1;
unique_ids = unique(imt_formatted.id);
mt_sinai_trial_table = [];
for j = 1:length(unique_ids)
    id = unique_ids(j);
    [func,type] = create_psychs_for_mt_sinai(imt_formatted, id, want_plot);
    row.id = id; 
    row.type = type;
    
    row.x_coord = func.a;
    row.y_coord = func.b;
    row.z_coord = func.c;

    mt_sinai_trial_table = [mt_sinai_trial_table; row];
end

mt_sinai_trial_table = struct2table(mt_sinai_trial_table);

%%

num_clusters = 4;
want_sign = 0;
k01_home_folder = "C:/Users/lrako/OneDrive/Documents/human_dm_data";
save_to = "C:\Users\lrako\OneDrive\Documents\human_dm\dec_2025\mt_sinai_original";
mkdir(save_to)

existing_table = "C:\Users\lrako\OneDrive\Documents\human_dm\dec_2025\mt_sinai_original\mt_sinai_clusters_original.xlsx";
mt_sinai_cluster_table = sinai_ghrelin_per_cluster...
    (existing_table, mt_sinai_trial_table, num_clusters, k01_home_folder, want_sign, save_to);

%writetable(mt_sinai_cluster_table,save_to + "\mt_sinai_clusters_original.xlsx","WriteMode","append")

%%

save_to = "C:\Users\lrako\OneDrive\Documents\human_dm\dec_2025\mt_sinai_original";
want_sign = 0;
mt_sinai_healthy_v_disorder_plot(mt_sinai_trial_table, want_sign, save_to)
