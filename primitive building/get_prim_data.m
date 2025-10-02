function mse = get_prim_data(spectral_table, all_data, story_types, use_cost)

totals = setup_for_avgs(all_data,story_types);
sesh_data = totals{1};
sesh_data = renamevars(sesh_data, 'story_type','experiment');


psych_to_cluster = psychs_in_spec_cluster(spectral_table, use_cost);

if use_cost
    merge = outerjoin(psych_to_cluster,sesh_data,'Keys',{'cost','story_num','subjectidnumber','experiment'},'MergeKeys',1);
else
    merge = outerjoin(psych_to_cluster,sesh_data,'Keys',{'story_num','subjectidnumber','experiment'},'MergeKeys',1);
end

sesh_table = merge(~isnan(merge.idx),:);


range = get_interactions(sesh_table);
cluster_mse = get_cluster_mse(range);
subj_var = get_subj_var(cluster_mse);
sesh_var = get_sesh_var(subj_var);
impulse = get_impulsivity(sesh_var);
appr_bias = get_appr_bias(impulse);
mse = get_mse(appr_bias);

end
