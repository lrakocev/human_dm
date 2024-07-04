function normalized_human_to_rat_comparison_single_plot(name_of_rat_file,human_cluster_table,directory_of_rat_file,b_dist_plots_dir,colors,normalize_or_dont)
% home_dir = cd(directory_of_human_file);
% % human_cluster_table = readtable(name_of_human_file);
% cd(home_dir)
home_dir = cd(directory_of_rat_file);
rat_table = readtable(name_of_rat_file);
cd(home_dir)

dir_with_b_dist_plots_abs = create_a_file_if_it_doesnt_exist_and_ret_abs_path(b_dist_plots_dir);

rat_clusters = unique(rat_table.cluster_number);
human_clusters = unique(human_cluster_table.cluster_number);


if normalize_or_dont
    human_data = [human_cluster_table.clusterX,human_cluster_table.clusterY,human_cluster_table.clusterZ];
    rescaled_human_data = normalize(human_data,"range",[0,1]);
    human_cluster_table.clusterX = rescaled_human_data(:,1);
    human_cluster_table.clusterY = rescaled_human_data(:,2);
    human_cluster_table.clusterZ = rescaled_human_data(:,3);

    rat_data = [rat_table.clusterX,rat_table.clusterY,rat_table.clusterZ];
    rescaled_rat_data = normalize(rat_data,"range",[0,1]);
    rat_table.clusterX = rescaled_rat_data(:,1);
    rat_table.clusterY = rescaled_rat_data(:,2);
    rat_table.clusterZ = rescaled_rat_data(:,3);
end
figure('units','normalized','outerposition',[0 0 1 1])
hs = [];
legend_strings = [];
for i=1:length(rat_clusters)

    current_rat_color = colors(i,:);
    rat_current_cluster_info = rat_table(rat_table.cluster_number==i,:);
    array_of_current_cluster_data_for_rat = [rat_current_cluster_info.clusterX,rat_current_cluster_info.clusterY,rat_current_cluster_info.clusterZ];
    % subplot(1,2,1);
    h = scatter3(array_of_current_cluster_data_for_rat(:,1),array_of_current_cluster_data_for_rat(:,2),array_of_current_cluster_data_for_rat(:,3),'o','MarkerEdgeColor',current_rat_color,'MarkerFaceColor',current_rat_color);
    legend_strings = [legend_strings,strcat("Dirk Cluster ",string(i))];
    hs = [hs,h];
    hold on;
    text(mean(array_of_current_cluster_data_for_rat(:,1)),...
        mean(array_of_current_cluster_data_for_rat(:,2)),...
        mean(array_of_current_cluster_data_for_rat(:,3))+4,...
        strcat("dirk ",string(i)),'FontWeight','bold','Color',current_rat_color);
    
    % plot3(rat_centers(i,1),rat_centers(i,2),rat_centers(i,3),"xk",MarkerSize=15,LineWidth=3);
    cell_array_of_b_dist = cell(length(human_clusters),1);
    array_of_cluster_labels_for_rat = logical(zeros(size(array_of_current_cluster_data_for_rat,1),1));

    to_be_x = cell(1,length(human_clusters));
end

for j=1:length(human_clusters)
    current_human_color = colors(length(rat_clusters)+j,:);
    human_current_cluster_info = human_cluster_table(human_cluster_table.cluster_number==j,:);
    array_of_current_cluster_data_for_human = [human_current_cluster_info.clusterX,human_current_cluster_info.clusterY,human_current_cluster_info.clusterZ];
    h = scatter3(array_of_current_cluster_data_for_human(:,1),array_of_current_cluster_data_for_human(:,2),array_of_current_cluster_data_for_human(:,3),'o','MarkerEdgeColor',current_human_color,'MarkerFaceColor',current_human_color);
    hs = [hs,h];
    legend_strings = [legend_strings,strcat("Human Cluster ",string(j))];
    % plot3(human_centers(j,1),human_centers(j,2),human_centers(j,3),"*k",MarkerSize=15,LineWidth=3);
    array_of_cluster_labels_for_human =logical(ones(size(array_of_current_cluster_data_for_human,1),1));
    cell_array_of_b_dist{j} = bhattacharyyaDistance([array_of_current_cluster_data_for_rat;array_of_current_cluster_data_for_human],[array_of_cluster_labels_for_rat;array_of_cluster_labels_for_human]);
    text(mean(array_of_current_cluster_data_for_human(:,1)),...
        mean(array_of_current_cluster_data_for_human(:,2)),...
        mean(array_of_current_cluster_data_for_human(:,3))+4,...
        strcat("human ",string(j)),'FontWeight','bold','Color',current_human_color);
    to_be_x{j} = char(string(human_clusters(j)));
end
hold off;
if normalize_or_dont
    to_add_to_title = "Normalized";
else
    to_add_to_title = "Not Normalized";
end
set(gcf,'renderer','Painters');

xlabel("log(abs(max))");
ylabel("log(abs(shift))");
zlabel("log(abs(slope))");

title("Dirk vs Human Cluster Comparison, " + to_add_to_title)

legend(hs,legend_strings,'Location','best')
saveas(gcf,strcat(dir_with_b_dist_plots_abs,"\Rat To Human Comparison ",to_add_to_title,".svg"),"svg")
saveas(gcf,strcat(dir_with_b_dist_plots_abs,"\Rat To Human Comparison ",to_add_to_title,".fig"),"fig")
end