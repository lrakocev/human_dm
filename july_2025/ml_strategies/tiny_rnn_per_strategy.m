%% get a single subject's behavioral data

%all_initial_data.norm_saccades = all_initial_data.num_saccads ./ all_initial_data.q_length;

id_data = group_by_feature(all_initial_data, "subjectidnumber");
features = ["story_type","rew", "cost","approach_rate"];

% ...
%    "num_guesses", "reaction_time", "pupil_diameter", "norm_saccades",
r_sqs = [];
for j = 1 :length(id_data)
    input_table = id_data{j};

     seq_table = get_sequence_for_hmm(input_table, features, 0);

     % excluding story_type (first variable) here so that everything comes
     % out as a number - will add after
     subject_data = table2array(seq_table(:,2:end));
     onehot_story_type = onehotencode(categorical(seq_table.story_type),2);

     % goes first cause approach_rate needs to be last (for grabbing
     % Ytrain)
     subject_data = [onehot_story_type subject_data];

     nan_rows = sum(isnan(subject_data),2);
     cleaned_data = subject_data(nan_rows == 0, :);

    numObservations = length(cleaned_data);
    numDims = size(cleaned_data, 2);
    
    idx = randperm(numObservations);
    numTrain = floor(0.8 * numObservations);

        
    %XTrain = cleaned_data(idx(1:numTrain-1),1:numDims);
    %YTrain = cleaned_data(idx(2:numTrain),numDims);

    XTrainData = cleaned_data(idx(1:numTrain-1),1:numDims);
    YTrainData = cleaned_data(idx(2:numTrain),numDims);
    
    sequenceLength = 10;
    XTrain = {};
    YTrain = {};
    for i = 1:size(XTrainData,1) - sequenceLength
        XTrain{end+1} = XTrainData(i:i+sequenceLength-1, :);
        YTrain{end+1} = YTrainData(i+sequenceLength);
    end

    XTest = cleaned_data(idx(numTrain:end-1),1:numDims);
    YTest = cleaned_data(idx(numTrain+1:end),numDims);
    

    % tiny rnn
    
    numFeatures = numDims; % Number of features in each time step
    numHiddenUnits = 64; % Number of hidden units in the LSTM layer
    outputSize = 1;
    
    layers = [
        sequenceInputLayer(numFeatures)
        gruLayer(numHiddenUnits,'OutputMode','sequence','Name','gru') % 'last' for sequence-to-one
        fullyConnectedLayer(outputSize,'Name','fc') % Output layer for a single regression value
        ];
      
    options = trainingOptions('adam', ...
        'ValidationData',{XTest,YTest}, ...
        'ValidationFrequency',10, ...
        'ValidationPatience',5,...
        'InitialLearnRate', 0.005, ...
        'MaxEpochs', 200, ...
        'Verbose', false);
         'Plots', 'training-progress', ...

    
    local_rqs = [];
    for k = 1:5
        net = trainnet(XTrain,YTrain,layers,"mse",options);

        YPred = predict(net,XTest);
                
        sse = sum((YPred - YTest).^2);
        sst = sum((YTest - mean(YTest)).^2);
        r2 = 1 - (sse/sst);
        local_rqs = [local_rqs; r2];
    end

    local_rqs = local_rqs(abs(local_rqs) <=1 ); 
    
    r_sqs = [r_sqs; max(local_rqs)];
end