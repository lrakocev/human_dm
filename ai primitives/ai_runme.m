%% ai primitives runme

% what i need from the model -- given R, C, give a value A (approach rate)
% train on human maps that are labeled 

%nss = idNeuralStateSpace(2,NumInputs=1);
%dlnet = createMLPNetwork(nss, 'state', LayerSizes = [4 8 4], Activation="sigmoid");

tot_appr = [];
for i = 1:length(approach_data)
    tot_appr = [tot_appr; approach_data{i}];
end

tot_appr.r_c_label = "(" + string(tot_appr.rew) + ", " + string(tot_appr.cost) + ")";

tot_appr.r_c_label = categorical(tot_appr.r_c_label);

n = height(tot_appr);
all_idx = 1:n;
num_train = round(n*.8);
num_test = n - num_train;
train_idx = randperm(n,num_train);
test_idx = setdiff(all_idx,train_idx);
train_table = tot_appr(train_idx,:);
test_table = tot_appr(test_idx,:);

Mdl = fitcnet(train_table,"r_c_label");
testAccuracy = 1 - loss(Mdl,test_table,"r_c_label", "LossFun","classiferror")

