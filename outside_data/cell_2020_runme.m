load('light_twdb_2020-03-13.mat')
twdb = struct2table(twdb);

%%
upToLearned = 1;
reversal = 0;
unique_ids = unique(twdb.mouseID);

cell_2020_psych_table = [];
for j = 1:length(unique_ids)
    id = unique_ids{j};
    mouse_twdb = twdb(twdb.mouseID == string(id), :);

    indices = mouse_twdb.index;
    trial_table = [];
    for i = 1:length(indices)
        index = indices(i);

        curr_trial_row = mouse_twdb(mouse_twdb.index == index, :);

        if curr_trial_row.taskType == "2tr"
            continue
        end

        curr_trial_table = curr_trial_row.trialData{1};

        if width(curr_trial_table) ~= 13
            curr_trial_table.Engagement = repelem(NaN,height(curr_trial_table), 1);
        end

        try
            trial_table = [trial_table; curr_trial_table];
        catch
            continue
        end
    end
    
    try
        [func, type] =  cell_data_single_psych(trial_table);
        
        row.ID = id;
        row.raw_x = func.a;
        row.raw_y = func.b;
        row.raw_z = func.c;
    
    catch
        continue
    end
    cell_2020_psych_table = [cell_2020_psych_table; row];

end

cell_2020_psych_table = struct2table(cell_2020_psych_table);


%%

cell_psych_plus_mice = outerjoin(cell_2020_psych_table, struct2table(miceType), 'MergeKeys',1,"Keys",{'ID'});
cell_psych_plus_mice = cell_psych_plus_mice(~isnan(cell_psych_plus_mice.raw_x), :);

cell_psych_plus_mice.x_coord = log(abs(cell_psych_plus_mice.raw_x));
cell_psych_plus_mice.y_coord = log(abs(cell_psych_plus_mice.raw_y));
cell_psych_plus_mice.z_coord = log(abs(cell_psych_plus_mice.raw_z));

%%
matrix = cell_psych_plus_mice(cell_psych_plus_mice.intendedStriosomality == "Matrix", :);
strio = cell_psych_plus_mice(cell_psych_plus_mice.intendedStriosomality == "Strio", :);

cluster_table = readtable("all_clusters_subject.xlsx");

figure
hum_scat = scatter3(cluster_table.clusterX, cluster_table.clusterY, cluster_table.clusterZ,1,'g','o');
hold on
mat_scat = scatter3(matrix.x_coord, matrix.y_coord, matrix.z_coord, 'r');
hold on
strio_scat = scatter3(strio.x_coord, strio.y_coord, strio.z_coord, 'b');
 
legend([hum_scat; mat_scat; strio_scat], ["human";"matrix"; "strio"])

xlabel("x coord")
ylabel("y coord")
zlabel("z coord")
title("psychometric funcs of mice w/ matrix vs strio intendedStriosomality")
