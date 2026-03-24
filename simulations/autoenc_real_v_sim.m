load("C:\Users\lrako\OneDrive\Documents\human_dm_data\autoenc_sim.mat")

sim_autoenc = autoenc;
sim_data = imageDataCellArray;

%% real data
load("C:\Users\lrako\OneDrive\Documents\human_dm\autoencoder_table.mat")

real_data = imageDataCellArray;

%%

encodedData = encode(sim_autoenc, [sim_data; real_data]);

encoded3D = tsne(encodedData', 'NumDimensions', 3);


% Plot the 2D visualization
figure;
scatter3(encoded3D(1:length(sim_data),1), encoded3D(1:length(sim_data),2), encoded3D(1:length(sim_data),3),'b','o');
hold on
scatter3(encoded3D(length(sim_data):end,1), encoded3D(length(sim_data):end,2), encoded3D(length(sim_data):end,3),'r','x');

title('autoencoder real vs sim points');
xlabel('auto x');
ylabel('auto y');
zlabel('auto z');
