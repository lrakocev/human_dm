function total_fit = create_sigmoids(home_dir, story_types, data, by_session, sig_type)

total_fit = 0;
for s = 1:length(story_types)
    story_type = story_types(s);
    combined_data = data{s};
    dirName = home_dir + story_type + "\" ;
            
    if by_session
        fit_count = sigmoid_analysis_updated(combined_data, dirName, sig_type);
        total_fit = total_fit + fit_count;
    else
        sigmoid_analysis_cost(combined_data, dirName, sig_type)
    end
end

end