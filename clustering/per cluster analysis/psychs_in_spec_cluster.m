function finTable = psychs_in_spec_cluster(humanTable)

humanTable.clusterLabels = string(humanTable.clusterLabels);
ids = rowfun(@get_id,humanTable,"InputVariables","clusterLabels","OutputVariableNames","subjectidnumber");
story_nums = rowfun(@get_story_num,humanTable,"InputVariables","clusterLabels","OutputVariableNames","story_num"); 
costs = rowfun(@get_cost_lvl,humanTable,"InputVariables","clusterLabels","OutputVariableNames","cost");
newTable = [humanTable ids story_nums costs];
finTable = renamevars(newTable,'cluster_number','idx');

end

function id = get_id(E)

list = strsplit(E,"_");
id = str2num(list(1));
if isempty(id)
    id = "avg";
end

end

function story_num = get_story_num(E)
list = strsplit(E,"_");
story_num = "story_" + string(list(3));
end

function cost = get_cost_lvl(E)

list = strsplit(E,"_");
cost_str = list(5);
cost_list = strsplit(cost_str,".");
cost = str2num(cost_list(1));
end


