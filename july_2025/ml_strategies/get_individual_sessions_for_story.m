function combined_data = get_individual_sessions_for_story(approach_data)

combined_data = {};
counter = 1;
for N = 1:length(approach_data)
    appr_table = approach_data{N};

    if ~isempty(appr_table)
        unique_stories = unique([appr_table.story_num, appr_table.story_type], 'rows');
            for j = 1:size(unique_stories,1)
                
                story = unique_stories(j,:);
                
                  
                story_table = appr_table(appr_table.story_num == story(1) & appr_table.story_type == story(2), :);
                combined_data{counter} = story_table;
                counter = counter + 1;
            end
        
    end
end

end

