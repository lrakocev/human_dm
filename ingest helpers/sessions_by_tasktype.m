function sessions = sessions_by_tasktype(approach_data, story_type)

sessions = cell(1,length(approach_data));
j = 1;
for N = 1:length(approach_data)
    appr_table = approach_data{N};
    unique_ids = unique(appr_table.subjectidnumber);
    for u = 1:length(unique_ids)
        id = unique_ids(u);
        id_table = appr_table(appr_table.subjectidnumber == id, :);
        if ~isempty(id_table)
            story_nums = unique(id_table.story_num);
            for s = 1:length(story_nums)
                story_num = story_nums(s);
                if ~isequal(story_type, "")
                    sesh = id_table(id_table.story_num == story_num & id_table.story_type == story_type, :);
                else
                    sesh = id_table(id_table.story_num == story_num, :);
                end
                if ~isempty(sesh)
                    sessions{j} = sesh;
                    j = j + 1;
                end
            end
        end
    end
end

end