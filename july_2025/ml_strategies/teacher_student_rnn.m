%% same xtest, ytest as in tiny_rnn_per_strategy.m
%%

teacherLayers = [ ...
    sequenceInputLayer(1)
    lstmLayer(20,'OutputMode','sequence') % num hidden states in paper
    fullyConnectedLayer(1)
    ];

options = trainingOptions("sgdm", ...
    MaxEpochs=4, ...
    Verbose=false, ...
    Plots="training-progress", ...
    Metrics="accuracy");

teacherNet = trainnet(X', teacherLayers, "crossentropy", options);

%%

teacherOutput = predict(teacherNet, X);

%%

studentLayers = [ ...
    sequenceInputLayer(1)
    lstmLayer(10,'OutputMode','sequence') % Small hidden state
    fullyConnectedLayer(1)
    regressionLayer];

% Train student to mimic teacher
studentNet = trainNetwork(X, teacherOutput, studentLayers, options);