function total_fit = create_sigmoids(home_dir, story_types, data, by_session, sig_type, thresh, is_sigmoidal)

total_fit = 0;
for s = 1:length(story_types)
    story_type = story_types(s);
    combined_data = data{s};
    dirName = home_dir + story_type + "/" ;
            
    if by_session
        if is_sigmoidal
            fit_count = sigmoid_analysis_updated(combined_data, dirName, sig_type, thresh);
            total_fit = total_fit + fit_count;
        else
            fit_2d_pig(combined_data, dirName, sig_type, thresh);
        end
    else
        if is_sigmoidal
            sigmoid_analysis_cost(combined_data, dirName, sig_type, thresh);
        else
            fit_pig(combined_data, dirName, sig_type, thresh);
        end
    end
end

end