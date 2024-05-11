function [table_of_data_dirs] = get_dirs_with_data(dir_with_all_sigmoid_data)
    home_dir = cd(dir_with_all_sigmoid_data);
    directory_which_contains_subdirectories_of_data = pwd;
    all_directories_within_this_one = ls(pwd);
    all_directories_within_this_one = string(all_directories_within_this_one);
    all_directories_within_this_one = string(strtrim(all_directories_within_this_one));

    all_directories_within_this_one = removeDotAndDotDot(all_directories_within_this_one);
   

    all_absolute_dirs = cell(length(all_directories_within_this_one),1);

    
    for i=1:length(all_directories_within_this_one)
        cd(all_directories_within_this_one(i))
        directory_with_sigmoid_data = ls(strcat(pwd,"\*Sigmoid*Data"));
        cd(directory_with_sigmoid_data);
        all_absolute_dirs{i} = pwd;
        cd(directory_which_contains_subdirectories_of_data);
    end

    table_of_data_dirs = table(all_directories_within_this_one,string(all_absolute_dirs),'VariableNames',["Task","Data_Directory"]);
    cd(home_dir)
end