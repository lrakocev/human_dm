function subj_var = get_rat_prim_data(rat_table, all_data)
 % prims = impulse, appr/avoid heavy, valuation, elasticity, mse

rat_table = renamevars(rat_table,'cluster_number','idx');
all_data.clusterLabels = all_data.subjectid + " " + strrep(all_data.date,"/","-") + ".mat";
merge = outerjoin(rat_table,all_data,'Keys',{'clusterLabels'},'MergeKeys',1);
sesh_table = merge(~isnan(merge.idx),:);

impulse = get_rat_impulsivity(sesh_table);
appr_bias = get_rat_appr_bias(impulse);
mse = get_rat_randomness(appr_bias);
interact = get_rat_interact(mse);
sesh_var = get_rat_var(interact);
cluster_mse = get_rat_cluster_mse(sesh_var);
subj_var = get_rat_subj_var(cluster_mse);


end
