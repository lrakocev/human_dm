function file_table = parse_filenames(file_array)

file_table = [];
for j = 1:length(file_array)
    filename = file_array{j};
    path_info = split(filename, "\");
    story_type = path_info(end-1);
    actual_file = path_info(end);
    file_info = split(actual_file, "_");
    id = file_info(2);
    try
        story = file_info(6); %4
    catch
        story = file_info(5);
    end
      

    story_list = split(story, ".");
    clean_story = story_list(1);
    
    file_row.story_type = story_type;
    file_row.subjectidnumber = id;
    file_row.story_num = "story_" + clean_story;

    file_table = [file_table; file_row];
end

file_table = struct2table(file_table);
end