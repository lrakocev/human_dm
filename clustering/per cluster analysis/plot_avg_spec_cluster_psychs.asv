function all_psych_data = plot_avg_spec_cluster_psychs(spectral_table, all_data, same_scale, story_types, save_to, want_plot)

totals = setup_for_avgs(all_data,story_types);

all_psych_data = [];
for s = 1:length(story_types)
    story_type = story_types(s);
    if story_type == "all"
        story_table = spectral_table;
    else
        story_table = spectral_table(spectral_table.experiment == story_type, :);
    end
    sesh_data = totals{s};

    psych_to_cluster = psychs_in_spec_cluster(story_table);
    all_psych_data = [all_psych_data; psych_to_cluster];

    if want_plot
        create_avg_psych(sesh_data,psych_to_cluster,story_type + " avg psych",same_scale,save_to)
        create_avg_map(sesh_data,psych_to_cluster,story_type + " map", same_scale, save_to)
    end
end
end