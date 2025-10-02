function fileList = get_all_filenames(dirName)

dirData = dir(dirName); % Get the data for the current directory.
dirIndex = [dirData.isdir]; % Find the index for directories.

% Get a list of the files in the current directory.
filesInCurrentDir = {dirData(~dirIndex).name}'; 
if ~isempty(filesInCurrentDir)
    % Prepend the path to the files.
    filesInCurrentDir = cellfun(@(x) fullfile(dirName, x), ...
                                filesInCurrentDir, 'UniformOutput', false);
end

fileList = filesInCurrentDir; 
subDirs = {dirData(dirIndex).name}; 

validIndex = ~ismember(subDirs, {'.', '..'}); 

for iDir = find(validIndex) 
    nextDir = fullfile(dirName, subDirs{iDir}); % Get the subdirectory path.
    fileList = [fileList; get_all_filenames(nextDir)]; % Recursively call and append.
end

end
