function new_table = add_story_column(appr_table)

new_table = [];
if ~isempty(appr_table)
    new_table = [];
    for r = 1:height(appr_table)    
        row = appr_table(r,:);
        try
            story = row.story_num;
        catch 
            story = row.tasktypedone;
        end
        split_story = split(story,'/');
        story_type = split_story(2);
        story_num = split_story(3);
        row.story_type = story_type;
        row.story_num = story_num;
        new_table = [new_table; row];
    end
end