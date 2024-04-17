function [idx1,p1] = createThePlotWithGM(xVsY1,sesh_names,num_clusters,task_1,start_means,alt_means,type,save_to)

color = lines(2*num_clusters);

is_avg = contains(sesh_names,"avg");

xVsY1_avg = xVsY1(is_avg,:);
xVsY1 = xVsY1(~is_avg,:);

try
    gm1 = fitgmdist(xVsY1, num_clusters, 'Start',start_means);
catch
    gm1 = fitgmdist(xVsY1, num_clusters-1, 'Start',alt_means);
    l = ["1";"2";"3";"avg"];
end

idx1 = cluster(gm1, xVsY1);
p1 = get_probs(idx1);

figure
gscatter(xVsY1(:,1),xVsY1(:,2),idx1,color(1:4,:));
hold on
scatter(xVsY1_avg(:,1),xVsY1_avg(:,2),'black','filled')
title(task_1)
savefig(save_to + type + "_" + "_clusters_2d.fig")

if length(unique(idx1)) == 4
    l = ["1";"2";"3";"4";"avg"];
else
    l = ["1";"2";"3";"avg"];
end

legend(l)
end

function ps = get_probs(idx)

tot = length(idx);
unique_ids = sort(unique(idx));

ps = [];
for i = 1:length(unique_ids)
    n = unique_ids(i);
    num = sum(idx == n);
    ps = [ps; num/tot];
end
end