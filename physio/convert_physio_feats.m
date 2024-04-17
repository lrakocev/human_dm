function new_table = convert_physio_feats(init_table)

new_table = []; 
subjects = unique(init_table.subjectidnumber);

for i = 1:length(subjects)
    id = subjects(i);
    sub_table = init_table(init_table.subjectidnumber == id, :);
    stories = unique(sub_table.story_num);
    for s = 1:length(stories)
        story = stories(s);
        story_table = sub_table(sub_table.story_num == string(story), :);
        for c = 1:4
            c_lvl_table = story_table(story_table.real_c == c, :);
            if ~isempty(c_lvl_table)
                M = varfun(@nanmean, c_lvl_table, 'InputVariables', @isnumeric);
                M.story_num = c_lvl_table.story_num(1);
                M.story_type = c_lvl_table.story_type(1);
                M = renamevars(M,"nanmean_real_c","cost");
                M = renamevars(M,"nanmean_subjectidnumber","subjectidnumber");
                new_table = [new_table; M];
            end
        end
    end
end

end