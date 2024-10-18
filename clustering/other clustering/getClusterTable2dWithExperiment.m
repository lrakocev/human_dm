function cluster= getClusterTable2dWithExperiment(yVsZ,raw_yVsZ,labels,indexes,cluster_id,experiment)
%xvsY is 1row x 2 col array 
%labels are all labels of the data
%indexes are the indexes of the labels that belong to cluster the cluster
%cluster is the table that represents the cluster
    clusterY = yVsZ(indexes==cluster_id,1);
    clusterZ = yVsZ(indexes==cluster_id,2);

    if ~isempty(raw_yVsZ)
        rawY = raw_yVsZ(indexes==cluster_id,1);
        rawZ = raw_yVsZ(indexes==cluster_id,2);
    end
    
    if ~isempty(labels)
        clusterLabels = labels(indexes==cluster_id).';
        clusterLabels = clusterLabels.';
    end
    cluster_number = repelem(cluster_id,length(clusterY)).';

    if ~isempty(experiment)
        experiment =experiment(indexes==cluster_id,1);
        experiment = experiment;
    else
        experiment = repelem("n/a", length(clusterY))';
    end

    if ~isempty(labels)
        cluster = table(clusterLabels,clusterY,clusterZ,cluster_number,experiment);
    elseif ~isempty(raw_yVsZ)
        cluster = table(clusterLabels,clusterY,clusterZ,cluster_number,rawY,rawZ,experiment);
    else
        cluster = table(clusterY,clusterZ,cluster_number,experiment);
    end 
end