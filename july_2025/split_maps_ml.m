imageDir = 'C:\Users\lrako\OneDrive\Documents\human dm\july_2025\dec_making_maps';

imds = imageDatastore(imageDir, 'IncludeSubfolders', true);
augmentedImds = transform(imds, @(data) ({data, data}));

imageDataCellArray = readall(imds);

%% autoencoder attempt 

hiddenSize = 25;
autoenc = trainAutoencoder(imageDataCellArray,hiddenSize,...
        'MaxEpochs', 400,...
        'L2WeightRegularization',0.004,...
        'SparsityRegularization',4,...
        'SparsityProportion',0.15);

%{
ex_im = imread('C:\Users\lrako\OneDrive\Documents\human dm\july_2025\dec_making_maps\approach_avoid\map_11464_story_10.png');
[rows, columns, numberOfColorChannels] = size(ex_im);
imageSize = [rows, columns, numberOfColorChannels]; % Adjust based on your image size

encoderLayers = [
    imageInputLayer(imageSize, 'Name', 'input')
    convolution2dLayer(3, 16, 'Padding', 'same', 'Name', 'conv1')
    reluLayer('Name', 'relu1')
    maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool1')
    convolution2dLayer(3, 32, 'Padding', 'same', 'Name', 'conv2')
    reluLayer('Name', 'relu2')
    maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool2')
];

decoderLayers = [
    transposedConv2dLayer(2, 32, 'Stride', 2, 'Name', 'tconv1')
    reluLayer('Name', 'relu3')
    transposedConv2dLayer(2, 16, 'Stride', 2, 'Name', 'tconv2')
    reluLayer('Name', 'relu4')
    convolution2dLayer(3, imageSize(3), 'Padding', 'same', 'Name', 'conv3') % Output layer matching input
    %regressionLayer('Name', 'output')
];

layers = [encoderLayers; decoderLayers];

options = trainingOptions('adam', ...
    'InitialLearnRate', 0.001, ...
    'MaxEpochs', 20, ...
    'MiniBatchSize', 32, ...
    'Shuffle', 'every-epoch', ...
    'Plots', 'training-progress');

net = trainnet(augmentedImds, layers, 'mse', options);
%}

encodedData = encode(autoenc, imageDataCellArray);
%%
% Use t-SNE to reduce the data to 2 dimensions for visualization
encoded2D = tsne(encodedData);

% Plot the 2D visualization
figure;
scatter(encoded2D(:,1), encoded2D(:,2));
title('2D Visualization of Encoded Data');
xlabel('Dimension 1');
ylabel('Dimension 2');
%%
% Use t-SNE to reduce the data to 2 dimensions for visualization
encoded3D = tsne(encodedData, 'NumDimensions',3);

% Plot the 2D visualization
figure;
scatter3(encoded3D(:,1), encoded3D(:,2), encoded3D(:,3));
title('3D Visualization of Encoded Data');
xlabel('Dimension 1');
ylabel('Dimension 2');

%{
softnet = trainSoftmaxLayer(feat2,tTrain,'MaxEpochs',400);

stackednet = stack(autoenc1,autoenc2,softnet);

xTrain = zeros(inputSize,numel(xTrainImages));
for i = 1:numel(xTrainImages)
    xTrain(:,i) = xTrainImages{i}(:);
end

% Perform fine tuning
stackednet = train(stackednet,xTrain,tTrain);
%}