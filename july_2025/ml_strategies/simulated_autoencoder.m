%% simulated auto encoder

num_random_maps = 200;
path_to_save = "C:\Users\lrako\OneDrive\Documents\human_dm\hmms\simulated_dec_making_maps";
mkdir(path_to_save)
for j = 1:num_random_maps
    make_random_dec_making_plots(path_to_save, j)
end

%%

dir_name = "C:\Users\lrako\OneDrive\Documents\human_dm\hmms\simulated_dec_making_maps";
save_to = "C:\Users\lrako\OneDrive\Documents\human_dm\hmms\simulated_small_dec_making_maps";
mkdir(save_to)
resizing_images(dir_name,save_to)

%% 
imageDir = 'C:\Users\lrako\OneDrive\Documents\human_dm\hmms\simulated_dec_making_maps';

imds = imageDatastore(imageDir, 'IncludeSubfolders', true);
augmentedImds = transform(imds, @(data) ({data, data}));

imageDataCellArray = readall(imds);

%% autoencoder training 

training_size = 75;
train_idx = randi(length(imageDataCellArray),1,training_size);
trainingImgs = imageDataCellArray(train_idx);
hiddenSize = 25;
autoenc = trainAutoencoder(trainingImgs,hiddenSize,...
        'MaxEpochs', 400,...
        'L2WeightRegularization',0.004,...
        'SparsityRegularization',4,...
        'SparsityProportion',0.15);

encodedData = encode(autoenc, imageDataCellArray);


%% 3D viz
% Use t-SNE to reduce the data to 2 dimensions for visualization
encoded3D = tsne(encodedData', 'NumDimensions',3);

% Plot the 2D visualization
figure;
scatter3(encoded3D(:,1), encoded3D(:,2), encoded3D(:,3));
title('3D Visualization of Encoded Data');
xlabel('Dimension 1');
ylabel('Dimension 2');
zlabel('Dimension 3')

autoencoder_feat_table = array2table(encoded3D, 'VariableNames', {'auto_x', 'auto_y', 'auto_z'});

