%% pre

%load("for_dirk_updated.mat")
story_types = unique(all_data.story_type);

for i = 1:length(story_types)
    story = story_types(i);
    task_combined_data = combine_for_map(all_trial_data, story);
    combined_data{i} = task_combined_data;
end

session_combined_data = get_individual_sessions_for_story(all_trial_data);


%%

story_types = unique(all_data.story_type);

for i = 1:length(story_types)
    story = story_types(i);
    task_session_data = sessions_by_tasktype(all_trial_data, story);
    session_data{i} = task_session_data;
end
%% get the maps

want_bdry = 0;
want_scale = 0;
want_save = 1;
for_ml = 1;
story_types = unique(all_data.story_type);
type = "approach_rate";
path_to_save = "C:\Users\lrako\OneDrive\Documents\human_dm\hmms\session_dec_making_maps";
mkdir(path_to_save)

run_dec_making_plot_loop(session_data,story_types,path_to_save,want_bdry,want_scale,want_save,for_ml,type)

%% resizing the maps (might need to run twice)

dir_name = "C:\Users\lrako\OneDrive\Documents\human_dm\hmms\session_dec_making_maps\";
save_to = "C:\Users\lrako\OneDrive\Documents\human_dm\hmms\small_session_maps";
mkdir(save_to)
resizing_images(dir_name,save_to)

%% convert to data cell array

imageDir = 'C:\Users\lrako\OneDrive\Documents\human_dm\hmms\small_session_maps';

imds = imageDatastore(imageDir, 'IncludeSubfolders', true);
augmentedImds = transform(imds, @(data) ({data, data}));

imageDataCellArray = readall(imds);

%% autoencoder training 

training_size = 150;
train_idx = randi(length(imageDataCellArray),1,training_size);
trainingImgs = imageDataCellArray(train_idx);
hiddenSize = 25;
autoenc = trainAutoencoder(trainingImgs,hiddenSize,...
        'MaxEpochs', 400,...
        'L2WeightRegularization',0.004,...
        'SparsityRegularization',4,...
        'SparsityProportion',0.15);

encodedData = encode(autoenc, imageDataCellArray);
%% Use t-SNE to reduce the data to 2 dimensions for visualization

encoded2D = tsne(encodedData');

% Plot the 2D visualization
figure;
scatter(encoded2D(:,1), encoded2D(:,2));
title('2D Visualization of Encoded Data');
xlabel('Dimension 1');
ylabel('Dimension 2');

%% 3D viz
% Use t-SNE to reduce the data to 2 dimensions for visualization
encoded3D = tsne(encodedData', 'NumDimensions', 3);

% Plot the 2D visualization
figure;
scatter3(encoded3D(:,1), encoded3D(:,2), encoded3D(:,3),1);
title('autoencoder session level pts');
xlabel('auto x');
ylabel('auto y');
zlabel('auto z');

autoencoder_feat_table = array2table(encoded3D, 'VariableNames', {'auto_x', 'auto_y', 'auto_z'}); %,'auto_a', 'auto_b', 'auto_c','auto_d', 'auto_e', 'auto_f'});


%% combine feature coords w/ their respective sessions

image_dir = "C:\Users\lrako\OneDrive\Documents\human_dm\hmms\small_session_maps";
fileList = get_all_filenames(image_dir);
info_table = parse_filenames(fileList);
full_autoencoder_table = [autoencoder_feat_table info_table];

%%

category_auto =add_category(full_autoencoder_table,"story_categories.xlsx");

filtered_auto = category_auto(category_auto.story_category ~= "bad", :);

figure
scatter3(filtered_auto.auto_x, filtered_auto.auto_y, filtered_auto.auto_z, 1)
title("filtered")


%%
options = fcmOptions(NumClusters=15);
[~, U] = fcm(encoded3D, options);
[~, max_row_indices] = max(U);

full_autoencoder_table.auto_cluster = max_row_indices';

%%

scatter3(full_autoencoder_table.auto_x, full_autoencoder_table.auto_y, full_autoencoder_table.auto_z, 20, full_autoencoder_table.auto_cluster)

xlabel("auto x")
ylabel("auto y")
zlabel("auto z")
title("auto-encoder clusters on decision-making maps")
savefig("auto_encoder_clusters_7.fig")

%% separate clusters

cluster_subclusters(full_autoencoder_table, 3)