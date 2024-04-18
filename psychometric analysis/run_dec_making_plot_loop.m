function run_dec_making_plot_loop(data,story_types,path_to_save,want_bdry,want_scale,want_save)

for i = 1:length(story_types)
    combined_data = data{i};
    story_type = story_types{i};
    for N = 1:length(combined_data)
        curr_data = combined_data{N};
        if ~isempty(curr_data)
            make_dec_making_plots(curr_data, path_to_save, story_type,want_bdry,want_scale,want_save)
        end
    end
end
end