
%% color cost clusters by task

type = "all_cost_5_clusters";
table_name = "C:\Users\lrako\OneDrive\Documents\human dm\" + type + ".xlsx";
spectral_table = readtable(table_name);

story_types = ["approach_avoid","social","moral","probability"];
seen_types = [];
hs = [];
colors = distinguishable_colors(4);
for i = 1:height(spectral_table)
    row = spectral_table(i,:);
    exp = row.experiment{1};
    c = find(story_types==exp);
    h = scatter3(row.clusterX, row.clusterY, row.clusterZ, 10, colors(c, :));

    if ~ismember(string(exp),string(seen_types))
        hs = [hs; h];
        seen_types = [seen_types string(exp)];
    end
    hold on
end
legend(hs,story_types)
set(gcf,'renderer','Painters')