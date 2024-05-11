function plot_chain_validation(summary_table,all_psych_data,row_num,sort_type,save_to)

% replace w/ dist_from_mean
summary_table = summary_table( ~isnan(summary_table.dist_from_mean),:);
sorted_by_std_devs =  sortrows(summary_table,"dist_from_mean",sort_type);
top_row = sorted_by_std_devs(row_num,:);
t1 = top_row.t1;
c1 = top_row.c1;
t2 = top_row.t2;
c2 = top_row.c2;

figure 
plot_target_cluster(all_psych_data, t1, c1, t2, c2)
set(gcf,'renderer','Painters')
savefig(save_to + "/validate_chain_ex_" + sort_type + ".fig")

end

function plot_target_cluster(all_psych_data, t1, c1, t2, c2)

t1c1_data = unique(all_psych_data(all_psych_data.story_type == t1 & all_psych_data.idx == c1, :));
t2c2_data = unique(all_psych_data(all_psych_data.story_type == t2 & all_psych_data.idx == c2, :));

t2c2_ids = unique(t2c2_data.subjectidnumber);

tot_in = 0;
tot_not = 0;
for j = 1:height(t1c1_data)
    row = t1c1_data(j,:);
    id = row.subjectidnumber;
    if ismember(id, t2c2_ids)
        h1 = scatter3(row.clusterX, row.clusterY, row.clusterZ,50,"b",'filled');
        tot_in = tot_in + 1;
    else
        h2 = scatter3(row.clusterX, row.clusterY, row.clusterZ,50,"r",'filled');
        tot_not = tot_not + 1;
    end
    hold on
end
hold off 
if tot_not > 0 & tot_in > 0 
    legend([h1; h2],["in"; "not in"])
elseif tot_in > tot_not 
    legend(h1,{"in"})
else
    legend(h2, 'out')
end
title("which pts in " + t1 + " cluster " + c1 + " are also in " + t2 + " cluster " + c2)
subtitle("total in: " + tot_in + ", total not in: " + tot_not)
xlabel("log(abs(max))")
xlabel("log(abs(shift))")
xlabel("log(abs(slope))")

end