function rulesTable = getLeafRules(tree)
    % Initialize an empty table to store the rules
    varNames = {'LeafNode', 'Rules', 'PredictedClass', 'NodeSize'};
    rulesTable = table('Size', [0, numel(varNames)], 'VariableTypes', {'double', 'string', 'string', 'double'}, 'VariableNames', varNames);

    % Get necessary tree properties
    isBranch = tree.IsBranchNode;
    cutVar = tree.CutVar;
    cutPoint = tree.CutPoint;
    children = tree.Children;
    class = tree.NodeClass;
    nodeSize = tree.NodeSize;

    % Call the recursive helper function
    rulesTable = traverse(1, "", rulesTable);
    
    function rulesTable = traverse(node, currentRules, rulesTable)
        if isBranch(node)
            % This is a branch node
            left_child = children(node, 1);
            right_child = children(node, 2);
            
            % Get the split variable and point
            variable = cutVar{node};
            split_value = cutPoint(node);
            
            % Traverse left branch (rule is 'variable < split_value')
            leftRule = sprintf("%s < %.4f", variable, split_value);
            rulesTable = traverse(left_child, currentRules + leftRule + " and ", rulesTable);

            % Traverse right branch (rule is 'variable >= split_value')
            rightRule = sprintf("%s >= %.4f", variable, split_value);
            rulesTable = traverse(right_child, currentRules + rightRule + " and ", rulesTable);
        else
            % This is a leaf node, so append its rules to the table
            %finalRules = strip(currentRules, 'right', " and ");
            leafClass = string(class{node});
            leafSize = nodeSize(node);
            newRow = {node, currentRules, leafClass, leafSize};
            rulesTable = [rulesTable; newRow];
        end
    end
end
