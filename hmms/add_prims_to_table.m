function prim_table = add_prims_to_table(starting_table)

starting_table.clusterLabel = starting_table.subjectidnumber + "_story_" + starting_table.story_num;

range = get_interactions(starting_table, "clusterLabel");
%subj_var = get_subj_var(cluster_mse);
sesh_var = get_sesh_var(range, "clusterLabel");
impulse = get_impulsivity(sesh_var, "clusterLabel");
prim_table = get_appr_bias(impulse, "clusterLabel");
%cluster_mse = get_cluster_mse(appr_bias);
%prim_table = get_mse(cluster_mse,"clusterLabels_behavior_2d_sig_join");

end

