function resizing_images(dir_name, save_to)

cd(dir_name)
s = dir;
idx=~startsWith({s.name},'.') & [s.isdir];
folders={s(idx).name};

nfolders = length(folders);
for J = 1 : nfolders
   thisfolder = folders(J);
   fileinfo = dir(thisfolder{1});
   fileinfo([fileinfo.isdir]) = [];   %remove . .. and other folders
   nfiles = length(fileinfo);
   mkdir(save_to + "\" + thisfolder{1})
   for K = 1 : nfiles
       thisfile = fullfile(thisfolder{1}, fileinfo(K).name);
       thisimg = imread(thisfile);
       thisimg_smaller = imresize(thisimg, 0.25);
       imwrite(thisimg_smaller, save_to + "\" + thisfile)
   end
end

end