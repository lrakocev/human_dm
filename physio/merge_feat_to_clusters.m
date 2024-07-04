function merged_table = merge_feat_to_clusters(feat_table, all_psych_data, want_hr)

[feat_table] = add_story_column(feat_table);
    
% collapse on: subject, session, cost level
%new_table = convert_physio_feats(feat_table);
new_table = renamevars(feat_table,"real_c","cost");

% join tables + get rows with indexes
merged_table = outerjoin(all_psych_data,new_table, 'MergeKeys',true, 'Keys',{'story_type','subjectidnumber','story_num','cost'});
if ~want_hr
    merged_table = merged_table(~isnan(merged_table.idx) & ~isnan(merged_table.avg_eng), :);
else
     merged_table = merged_table(~isnan(merged_table.idx) & ~isnan(merged_table.avg_hr), :);
end

end