function resizing_images(dir_name, save_to)

cd(dir_name)
s = dir;
idx=~startsWith({s.name},'.') & [s.isdir];
folders={s(idx).name};

nfolders = length(folders);
if nfolders > 1
    for J = 1 : nfolders
       thisfolder = folders(J);
       do_thing_in_folder(thisfolder, nfolders, save_to)
    end
else
    thisfolder = dir_name;
    do_thing_in_folder(thisfolder, nfolders, save_to)
end

end

function do_thing_in_folder(thisfolder, nfolders, save_to)

fileinfo = dir(thisfolder{1});
fileinfo([fileinfo.isdir]) = [];   %remove . .. and other folders
nfiles = length(fileinfo);
if nfolders > 1
    mkdir(save_to + "\" + thisfolder{1})
end
for K = 1 : nfiles
   thisfile = fullfile(thisfolder{1}, fileinfo(K).name);
   thisimg = imread(thisfile);
   thisimg_smaller = imresize(thisimg, 0.25);
   if nfolders > 1
       filename = save_to  + "\" + thisfile;
   else 
       [pathstr, name, ext] = fileparts(thisfile);

       filename = save_to + "\" + name + ".png"; 
   end
   imwrite(thisimg_smaller, filename)
end
end
