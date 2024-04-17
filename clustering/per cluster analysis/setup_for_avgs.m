function totals = setup_for_avgs(data,story_types)

n = length(story_types);
totals = cell(1,n);
for i = 1:n    
    story_data = data{i};
    story_total = [];
    for j = 1:length(story_data)
        sesh = story_data{j};
        story_total = [story_total; sesh];
    end
    totals{i} = story_total;
end
