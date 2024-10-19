function full_table = run_alt_fit(data, story_types, want_poly)

full_table = [];
for s = 1:length(story_types)
    story_type = story_types(s);
    combined_data = data{s};
            
    if want_poly
        curr_table = get_poly_fit(combined_data, story_type);
    else
        curr_table = get_2d_sig_fit(combined_data, story_type);
    end
    full_table = [full_table; curr_table];
        
end

end