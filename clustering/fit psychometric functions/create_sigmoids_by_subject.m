function total_fit = create_sigmoids_by_subject(home_dir, story_types, data, by_session, sig_type, thresh, is_sigmoidal)

total_fit = 0;
for s = 1:length(story_types)
    story_type = story_types(s);
    combined_data = data{s};
    dirName = home_dir + story_type + "/" ;

    all_data = [];
    for j = 1:length(combined_data)
        all_data = [all_data; combined_data{j}];
    end

    unique_subjects = unique(all_data.subjectidnumber);
    for k = 1:length(unique_subjects)
        subject_data = all_data(all_data.subjectidnumber == unique_subjects(k), :);
        fit_2d_pig(subject_data, dirName, sig_type);

    end
end

end