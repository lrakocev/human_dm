function create_sigmoids(home_dir, story_types, data)

for s = 1:length(story_types)
    story_type = story_types(s);
    combined_data = data{s};
    dirName = home_dir + story_type + "\" ;
            
    sigmoidAnalysis_lara(combined_data, dirName)
end

end