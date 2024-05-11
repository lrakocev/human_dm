function list_of_files_without_the_shortcuts = removeDotAndDotDot(list_of_directories)
    list_of_files_without_the_shortcuts = [];
    for i=1:length(list_of_directories)
        if ~strcmpi(list_of_directories(i),".") && ~strcmpi(list_of_directories(i),"..")
            list_of_files_without_the_shortcuts = [list_of_files_without_the_shortcuts;list_of_directories(i)];
        end
    end
end