function state_table = describe_leaf_nodes(tree)

% Get leaf nodes
leafNodes = find(all(tree.Children == 0, 2));

predictors = string(tree.PredictorNames);
directions = "direction_" + predictors;
types = ["double" repelem("double",1,length(predictors)) repelem("string",1,length(directions))];

state_table = table('Size', [0,1+length(predictors)*2], 'VariableTypes', types, 'VariableNames', ["state" predictors directions]);

% Iterate through each leaf node
for i = 1:length(leafNodes)
    currentNode = leafNodes(i);
    pathDescription = {};

    % Trace path from leaf to root
    while tree.Parent(currentNode) ~= 0 % 0 indicates the root node
        parentNode = tree.Parent(currentNode);
        
        % Get split information at the parent node
        predictor = tree.CutPredictor{parentNode};
        cutPoint = tree.CutPoint(parentNode);
        cutCategories = tree.CutCategories{parentNode};

        % Determine which branch was taken to reach the current node
        if tree.Children(parentNode, 1) == currentNode % Left child
            if isempty(cutCategories) % Continuous predictor
                condition = sprintf('%s <= %g', predictor, cutPoint);
                state_table.(predictor)(i) = cutPoint;
                state_table.("direction_" + predictor)(i) = "less";
            else % Categorical predictor
                condition = sprintf('%s is in {%s}', predictor, strjoin(cutCategories{1}, ', '));
            end
        else % Right child
            if isempty(cutCategories) % Continuous predictor
                condition = sprintf('%s > %g', predictor, cutPoint);
                state_table.(predictor)(i) = cutPoint;
                state_table.("direction_" + predictor)(i) = "more";
            else % Categorical predictor
                % Assuming the right child represents categories not in cutCategories{1}
                condition = sprintf('%s is not in {%s}', predictor, strjoin(cutCategories{1}, ', '));
            end
        end
        pathDescription = [condition; pathDescription]; % Prepend to build path from root

        currentNode = parentNode;
    end

    node_class = str2double(tree.NodeClass{leafNodes(i)});
    state_table.state(i) = node_class;

    %fprintf('Leaf Node %d (Class: %d):\n', leafNodes(i), tree.ClassNames(node_class));
    for j = 1:length(pathDescription)
        fprintf('  - %s\n', pathDescription{j});
    end
    fprintf('\n');
end
end