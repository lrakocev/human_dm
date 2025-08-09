function cluster= getClusterTable3dWithExperiment(xVsYVsZ,raw_xVsYVsZ,labels,indexes,cluster_id,experiment)
%xvsY is 1row x 2 col array 
%labels are all labels of the data
%indexes are the indexes of the labels that belong to cluster the cluster
%cluster is the table that represents the cluster
    clusterX = xVsYVsZ(indexes==cluster_id,1);
    clusterY = xVsYVsZ(indexes==cluster_id,2);
    clusterZ = xVsYVsZ(indexes==cluster_id,3);

    if ~isempty(raw_xVsYVsZ)
        rawX = raw_xVsYVsZ(indexes==cluster_id,1);
        rawY = raw_xVsYVsZ(indexes==cluster_id,2);
        rawZ = raw_xVsYVsZ(indexes==cluster_id,3);
    end
    
    if ~isempty(labels)
        clusterLabels = labels(indexes==cluster_id).';
        clusterLabels = clusterLabels.';
    end
    cluster_number = repelem(cluster_id,length(clusterX)).';

    if ~isempty(experiment)
        experiment =experiment(indexes==cluster_id,1);
        experiment = experiment;
    else
        experiment = repelem("n/a", length(clusterX))';
    end

    if ~isempty(raw_xVsYVsZ)
        cluster = table(clusterLabels,clusterX,clusterY,clusterZ,cluster_number,rawX,rawY,rawZ,experiment);
    else
        cluster = table(clusterLabels,clusterX,clusterY,clusterZ,cluster_number,experiment);
    end 
end