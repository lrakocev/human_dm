function make_thresh_psych_folder(clean_approach_data, subject_prefs, thresh, existing_dir, story_types)

by_cost = 0;
if contains(existing_dir, "cost")
    by_cost = 1;
end
filtered_files = filter_helper(clean_approach_data, subject_prefs, thresh, by_cost);

new_dir = "psych_dir_thresh_" + string(thresh);
for i = 1:length(story_types)
    story = story_types(i);
    mkdir(new_dir + "/" + story + "/Sigmoid Data")
end

for i = 1:length(filtered_files)
    file = filtered_files(i);
    file_info = split(file,"/");
    story = file_info(1);
    full_path = existing_dir + "/" + file;
    new_path = new_dir + "/" + story + "/Sigmoid Data/";
    if exist(full_path,'file')
        copyfile(full_path,new_path)
    end
end


end