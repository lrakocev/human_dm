function plot_chain_validation_both(summary_table,all_psych_data,row_num,sort_type,save_to)

% replace w/ dist_from_mean
if sort_type == "desc"
    summary_table = summary_table( ~isnan(summary_table.dist_from_mean),:);
end
sorted_by_std_devs =  sortrows(summary_table,"dist_from_mean",sort_type);
top_row = sorted_by_std_devs(row_num,:);
prob = top_row.sample_mean;
t1 = top_row.t1;
c1 = top_row.c1;
t2 = top_row.t2;
c2 = top_row.c2;

figure 
plot_target_cluster(all_psych_data, t1, c1, t2, c2, prob)
set(gcf,'renderer','Painters')
savefig(save_to + "/validate_chain_ex_" + sort_type + ".fig")

end

function plot_target_cluster(all_psych_data, t1, c1, t2, c2, prob)

t1c1_data = unique(all_psych_data(all_psych_data.story_type == t1 & all_psych_data.idx == c1, :));
t2c2_data = unique(all_psych_data(all_psych_data.story_type == t2 & all_psych_data.idx == c2, :));

t1c1_str = string(t1) + " cluster " + string(c1);
t2c2_str = string(t2) + " cluster " + string(c2);

tot_in = 0;
tot_not = 0;
for j = 1:height(t1c1_data)
    row = t1c1_data(j,:);
    h1 = scatter3(row.clusterX, row.clusterY, row.clusterZ,50,"b",'filled');
    hold on
end

for j = 1:height(t2c2_data)
    row = t2c2_data(j,:);
    h2 = scatter3(row.clusterX, row.clusterY, row.clusterZ,50,"r",'filled');
    hold on
end

legend([h1; h2], [t1c1_str; t2c2_str])


title(t1c1_str + "->" + t2c2_str + " with prob: " + string(prob)) 
xlabel("log(abs(max))")
xlabel("log(abs(shift))")
xlabel("log(abs(slope))")

end