function probability_of_behavior(home_dir_name, sigmoid_type, num_clusters, means_2d)

max_v_shift_start_means = means_2d{1};
max_v_shift_alt_means =  means_2d{2};

max_v_slope_start_means = means_2d{3};
max_v_slope_alt_means = means_2d{4};

shift_v_slope_start_means = means_2d{5};
shift_v_slope_alt_means = means_2d{6};

story_types = ["moral","approach_avoid", "social", "probability"];
xlabels = ["max","max","shift"];
ylabels = ["shift","slope","slope"];

for s = 1:length(story_types)
    story_type = story_types(s);
    dirName = home_dir_name + story_type + "\";

    human_dir = dirName + 'Sigmoid Data';
    humanTable = stoppingPointsSigmoidClustering(human_dir);
    if sigmoid_type == "sessions"
        total_sessions = height(humanTable);
    else
        ids = [];
        for i = 1:height(humanTable)
            id = humanTable.D(i);
            id = id{1};
            ids = [ids; string(id(1:5))];
        end
        
        total_sessions = length(unique(ids));
    end
    
    sigmoidMax = log(abs(humanTable.A));
    horizShift = log(abs(humanTable.B));
    sigmoidSteepness = log(abs(humanTable.C));
    sesh_names = humanTable.E;
    
    is_avg = contains(sesh_names, 'avg');
    humanTable = humanTable(~is_avg,:);

    for l = 1:3
        x_label = xlabels(l);
        y_label = ylabels(l);
                
        if (isequal(x_label, 'max') && isequal(y_label, 'shift')) 
            data = [sigmoidMax, horizShift];
            start_means = max_v_shift_start_means;
            alt_means = max_v_shift_alt_means;

            [idx,~] = createThePlotWithGM(data,sesh_names,num_clusters,story_type,start_means,alt_means);
            close 

            max_v_shift_max = max(idx);
            humanTable.max_v_shift = idx;

        elseif isequal(x_label, 'max') && isequal(y_label, 'slope') 
            data = [sigmoidMax,sigmoidSteepness];
            start_means = max_v_slope_start_means;
            alt_means = max_v_slope_alt_means;

            [idx,~] = createThePlotWithGM(data,sesh_names,num_clusters,story_type,start_means,alt_means);
            close

            max_v_slope_max = max(idx);
            humanTable.max_v_slope = idx;

        elseif isequal(x_label, 'shift') && isequal(y_label, 'slope') 
            data = [horizShift,sigmoidSteepness];
            start_means = shift_v_slope_start_means;
            alt_means = shift_v_slope_alt_means;
            
            [idx,~] = createThePlotWithGM(data,sesh_names,num_clusters,story_type,start_means,alt_means);
            close 

            shift_v_slope_max = max(idx);
            humanTable.shift_v_slope = idx;
        end
    end

    figure
    % plotting all possible combinations
    for a1 = 1:num_clusters
        for a2 = 1:num_clusters
            for a3 = 1:num_clusters

                if (a3 > shift_v_slope_max) || (a2 > max_v_slope_max) || (a1 > max_v_shift_max)
                    scatter3(a1,a2,a3,10,'y')
                else
                    scatter3(a1,a2,a3,10,'b')
                end
                hold on
            end
        end
    end
    hold on

    % plotting the actual combinations
    triplets = humanTable(:, 6:8);
    pattern_table = groupcounts(triplets,["max_v_shift","max_v_slope","shift_v_slope"]);
    pattern_table.pattern = string(pattern_table.max_v_shift) + ", " + string(pattern_table.max_v_slope) + ", " + string(pattern_table.shift_v_slope);

    max_v_shift_cluster = pattern_table.max_v_shift;
    max_v_slope_cluster = pattern_table.max_v_slope;
    shift_v_slope_cluster = pattern_table.shift_v_slope;
    count = pattern_table.Percent;
    
    scatter3(max_v_shift_cluster, max_v_slope_cluster, shift_v_slope_cluster, count*10, 'r', 'filled');
    title(story_type + " probability of cluster patterns ")

    %{
    histogram('Categories',pattern_table.pattern,'BinCounts',pattern_table.Percent)
    ylabel("percent")
    xlabel("cluster patterns")
    title("% of pts in given cluster pattern for " + story_type)
    %}

    xlabel('Max V Shift Cluster')
    ylabel('Max V Slope Cluster')
    zlabel('Shift V Slope Cluster')
    figname = strcat(dirName,"/",story_type,"_prob_of_pattern.fig");
    fighandle = gcf;
    set(gcf,'renderer','Painters') 
    saveas(fighandle,figname)
    close all
end
end