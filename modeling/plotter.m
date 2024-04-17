function [example_advantage, strio_indxs,lh_indxs,da_indxs] = plotter(advantages,strio_incs,...
    lh_incs,da_incs)
    
    sampled_points_per_space = 10;

    unique_complexities_indx = [1 2 4 9 16];

    for i=1:3
        advantages_i = advantages{unique_complexities_indx(i)};

        % choose some arbitrary points and use them based on their
        % probability
        strio_indxs{i} = datasample(1:length(strio_incs),sampled_points_per_space);
        lh_indxs{i} = datasample(1:length(lh_incs),sampled_points_per_space);
        da_indxs{i} = datasample(1:length(da_incs),sampled_points_per_space);

        for j=1:sampled_points_per_space
            example_advantage_i(j) = advantages_i(strio_indxs{i}(j),lh_indxs{i}(j),da_indxs{i}(j));
            if example_advantage_i(j) > rand
                % remove point if it doesn't appear probabilistically
                strio_indxs{i}(j) = nan;
                lh_indxs{i}(j) = nan;
                da_indxs{i}(j) = nan;
            end
        end
        example_advantage{i} = example_advantage_i;
    end

    % bubble plot
    figure;
    hold on
    for i=1:3 
        scatter3(strio_indxs{i},lh_indxs{i},da_indxs{i},300*example_advantage{i},'filled')
    end
    hold off
    xlabel("sSPN activity (arb. u.)")
    ylabel("LHb activity (arb. u.)")
    zlabel("DA of SNc activity (arb. u.)")
    title("Circuit configurations where spaces with " + ...
        "different # components are acheived");
    subtitle("size = probability achieved at that configuration")
    view(3)
    legend(["space not formed","1D space","2D"])
    %legend(["space not formed","1D space","2D","3D","4D"])
    set(gcf,'renderer','painters');


end
