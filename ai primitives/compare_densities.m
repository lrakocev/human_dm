function non_mapping_idx = compare_densities(hum_data, theo_data, bhatt_table)

mapping = bhatt_table(bhatt_table.bhatt_dist <= 1, :);
hum_gc = groupcounts(hum_data, 'cluster_number');
theo_gc = groupcounts(theo_data,'cluster_number');

unique_hum_idx = unique(hum_data.cluster_number);
densities = [];
labels = [];
for i = 1:length(unique_hum_idx)
    hum_idx = unique_hum_idx(i);
    theo_indices = mapping(mapping.hum_idx == hum_idx, :).model_idx;
    
    theo_dens = sum(theo_gc(ismember(theo_gc.cluster_number, theo_indices), :).Percent);
    hum_dens = hum_gc(hum_gc.cluster_number == hum_idx, :).Percent;
    
    label = "hum " + string(hum_idx) + ", theo: " + join(string(theo_indices), ", ");
    labels = [labels; label];
    densities = [densities; hum_dens theo_dens];
end

mapping_idx = unique(mapping.model_idx);
non_mapping_idx = unique(theo_gc(~ismember(theo_gc.cluster_number,mapping_idx), :).cluster_number);
non_mapping_percent = sum(theo_gc(~ismember(theo_gc.cluster_number,mapping_idx), :).Percent);

densities = [densities; 0 non_mapping_percent];
labels = [labels; "all theo not mapping to hum"];

bar(densities)
legend(["human"; "theoretical"])
xlabel("mapping clusters")
xticklabels(labels)
ylabel("% of total space")

end
